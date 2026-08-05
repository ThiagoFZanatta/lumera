-- ============ INTER ============
CREATE TABLE public.inter_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  bank_account_id uuid REFERENCES public.bank_accounts(id) ON DELETE SET NULL,
  client_id text,
  client_secret text,
  cert_pem text,
  key_pem text,
  account_number text,
  environment text NOT NULL DEFAULT 'sandbox',
  active boolean NOT NULL DEFAULT true,
  last_balance numeric,
  last_balance_at timestamptz,
  last_sync_at timestamptz,
  last_test_at timestamptz,
  last_test_status text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id)
);
GRANT SELECT (id, company_id, bank_account_id, account_number, environment, active, last_balance, last_balance_at, last_sync_at, last_test_at, last_test_status, created_at, updated_at) ON public.inter_config TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.inter_config TO authenticated;
GRANT ALL ON public.inter_config TO service_role;
ALTER TABLE public.inter_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY inter_cfg_sel ON public.inter_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY inter_cfg_ins ON public.inter_config FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY inter_cfg_upd ON public.inter_config FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY inter_cfg_del ON public.inter_config FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_inter_config_updated BEFORE UPDATE ON public.inter_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ============ OPEN FINANCE (PLUGGY) ============
CREATE TABLE cofre.pluggy_secrets (
  company_id uuid PRIMARY KEY REFERENCES public.companies(id) ON DELETE CASCADE,
  client_id text,
  client_secret text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.openfinance_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  provider text NOT NULL DEFAULT 'pluggy',
  client_id_preview text,
  sandbox boolean NOT NULL DEFAULT true,
  active boolean NOT NULL DEFAULT true,
  last_test_at timestamptz,
  last_test_status text,
  last_sync_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, provider)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.openfinance_config TO authenticated;
GRANT ALL ON public.openfinance_config TO service_role;
ALTER TABLE public.openfinance_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY of_cfg_sel ON public.openfinance_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY of_cfg_ins ON public.openfinance_config FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY of_cfg_upd ON public.openfinance_config FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY of_cfg_del ON public.openfinance_config FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_openfinance_config_updated BEFORE UPDATE ON public.openfinance_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE OR REPLACE FUNCTION public.set_pluggy_credentials(p_company_id uuid, p_client_id text, p_client_secret text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, cofre AS $$
DECLARE v_prev text;
BEGIN
  IF NOT public.is_company_admin(p_company_id) THEN RAISE EXCEPTION 'Sem permissao'; END IF;
  IF coalesce(trim(p_client_id),'') = '' OR coalesce(trim(p_client_secret),'') = '' THEN
    RAISE EXCEPTION 'Informe client_id e client_secret';
  END IF;
  v_prev := repeat('*', greatest(length(p_client_id) - 4, 0)) || right(p_client_id, 4);
  INSERT INTO cofre.pluggy_secrets (company_id, client_id, client_secret)
  VALUES (p_company_id, p_client_id, p_client_secret)
  ON CONFLICT (company_id) DO UPDATE SET client_id = excluded.client_id, client_secret = excluded.client_secret, updated_at = now();
  INSERT INTO public.openfinance_config (company_id, provider, client_id_preview)
  VALUES (p_company_id, 'pluggy', v_prev)
  ON CONFLICT (company_id, provider) DO UPDATE SET client_id_preview = v_prev;
END; $$;
REVOKE ALL ON FUNCTION public.set_pluggy_credentials(uuid, text, text) FROM public, anon;
GRANT EXECUTE ON FUNCTION public.set_pluggy_credentials(uuid, text, text) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_pluggy_credentials(p_company_id uuid)
RETURNS jsonb LANGUAGE sql SECURITY DEFINER SET search_path = public, cofre AS $$
  SELECT jsonb_build_object('client_id', client_id, 'client_secret', client_secret)
  FROM cofre.pluggy_secrets WHERE company_id = p_company_id;
$$;
REVOKE ALL ON FUNCTION public.get_pluggy_credentials(uuid) FROM public, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_pluggy_credentials(uuid) TO service_role;

CREATE TABLE public.bank_connections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  provider text NOT NULL DEFAULT 'pluggy',
  external_id text NOT NULL,
  institution_name text,
  institution_image text,
  status text NOT NULL DEFAULT 'UPDATING',
  last_synced_at timestamptz,
  consent_expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, provider, external_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bank_connections TO authenticated;
GRANT ALL ON public.bank_connections TO service_role;
ALTER TABLE public.bank_connections ENABLE ROW LEVEL SECURITY;
CREATE POLICY bconn_sel ON public.bank_connections FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY bconn_ins ON public.bank_connections FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY bconn_upd ON public.bank_connections FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY bconn_del ON public.bank_connections FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_bank_connections_updated BEFORE UPDATE ON public.bank_connections FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.bank_transactions_raw (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  connection_id uuid REFERENCES public.bank_connections(id) ON DELETE CASCADE,
  provider text NOT NULL DEFAULT 'pluggy',
  external_id text NOT NULL,
  account_external_id text,
  date date NOT NULL,
  description text NOT NULL DEFAULT '',
  amount numeric NOT NULL DEFAULT 0,
  direction text NOT NULL DEFAULT 'expense',
  category text,
  payment_method text,
  status text NOT NULL DEFAULT 'new',
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  raw jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, provider, external_id)
);
CREATE INDEX idx_btr_company_status ON public.bank_transactions_raw (company_id, status, date DESC);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bank_transactions_raw TO authenticated;
GRANT ALL ON public.bank_transactions_raw TO service_role;
ALTER TABLE public.bank_transactions_raw ENABLE ROW LEVEL SECURITY;
CREATE POLICY btr_sel ON public.bank_transactions_raw FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY btr_ins ON public.bank_transactions_raw FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY btr_upd ON public.bank_transactions_raw FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY btr_del ON public.bank_transactions_raw FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_btr_updated BEFORE UPDATE ON public.bank_transactions_raw FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ============ WHATSAPP ============
CREATE TABLE public.whatsapp_configs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  instance_name text NOT NULL,
  evolution_api_url text,
  evolution_api_key text,
  webhook_secret text,
  phone_number text,
  notify_number text,
  group_jid text,
  group_name text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, instance_name)
);
GRANT SELECT (id, company_id, instance_name, evolution_api_url, webhook_secret, phone_number, notify_number, group_jid, group_name, active, created_at, updated_at) ON public.whatsapp_configs TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.whatsapp_configs TO authenticated;
GRANT ALL ON public.whatsapp_configs TO service_role;
ALTER TABLE public.whatsapp_configs ENABLE ROW LEVEL SECURITY;
CREATE POLICY wa_cfg_sel ON public.whatsapp_configs FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY wa_cfg_ins ON public.whatsapp_configs FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY wa_cfg_upd ON public.whatsapp_configs FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY wa_cfg_del ON public.whatsapp_configs FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_whatsapp_configs_updated BEFORE UPDATE ON public.whatsapp_configs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.whatsapp_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  config_id uuid REFERENCES public.whatsapp_configs(id) ON DELETE SET NULL,
  message_id text,
  phone_number text,
  direction text NOT NULL DEFAULT 'inbound',
  message_text text,
  message_type text NOT NULL DEFAULT 'text',
  media_url text,
  processed boolean NOT NULL DEFAULT false,
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  classification jsonb,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_wa_msg_company ON public.whatsapp_messages (company_id, created_at DESC);
CREATE UNIQUE INDEX idx_wa_msg_dedupe ON public.whatsapp_messages (company_id, message_id) WHERE message_id IS NOT NULL;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.whatsapp_messages TO authenticated;
GRANT ALL ON public.whatsapp_messages TO service_role;
ALTER TABLE public.whatsapp_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY wa_msg_sel ON public.whatsapp_messages FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY wa_msg_ins ON public.whatsapp_messages FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY wa_msg_upd ON public.whatsapp_messages FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY wa_msg_del ON public.whatsapp_messages FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

-- ============ CONTA AZUL ============
CREATE TABLE cofre.contaazul_secrets (
  company_id uuid PRIMARY KEY REFERENCES public.companies(id) ON DELETE CASCADE,
  client_id text,
  client_secret text,
  refresh_token text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.contaazul_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  client_id_preview text,
  ativo boolean NOT NULL DEFAULT true,
  last_import_at timestamptz,
  last_import_result jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.contaazul_config TO authenticated;
GRANT ALL ON public.contaazul_config TO service_role;
ALTER TABLE public.contaazul_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY ca_cfg_sel ON public.contaazul_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY ca_cfg_ins ON public.contaazul_config FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY ca_cfg_upd ON public.contaazul_config FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY ca_cfg_del ON public.contaazul_config FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_contaazul_config_updated BEFORE UPDATE ON public.contaazul_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE OR REPLACE FUNCTION public.set_contaazul_credentials(p_company_id uuid, p_client_id text, p_client_secret text, p_refresh_token text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, cofre AS $$
DECLARE v_prev text;
BEGIN
  IF NOT public.is_company_admin(p_company_id) THEN RAISE EXCEPTION 'Sem permissao'; END IF;
  IF coalesce(trim(p_client_id),'') = '' OR coalesce(trim(p_client_secret),'') = '' OR coalesce(trim(p_refresh_token),'') = '' THEN
    RAISE EXCEPTION 'Informe client_id, client_secret e refresh_token';
  END IF;
  v_prev := repeat('*', greatest(length(p_client_id) - 4, 0)) || right(p_client_id, 4);
  INSERT INTO cofre.contaazul_secrets (company_id, client_id, client_secret, refresh_token)
  VALUES (p_company_id, p_client_id, p_client_secret, p_refresh_token)
  ON CONFLICT (company_id) DO UPDATE SET client_id = excluded.client_id, client_secret = excluded.client_secret, refresh_token = excluded.refresh_token, updated_at = now();
  INSERT INTO public.contaazul_config (company_id, client_id_preview, ativo)
  VALUES (p_company_id, v_prev, true)
  ON CONFLICT (company_id) DO UPDATE SET client_id_preview = v_prev, ativo = true;
END; $$;
REVOKE ALL ON FUNCTION public.set_contaazul_credentials(uuid, text, text, text) FROM public, anon;
GRANT EXECUTE ON FUNCTION public.set_contaazul_credentials(uuid, text, text, text) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_contaazul_credentials(p_company_id uuid)
RETURNS jsonb LANGUAGE sql SECURITY DEFINER SET search_path = public, cofre AS $$
  SELECT jsonb_build_object('client_id', client_id, 'client_secret', client_secret, 'refresh_token', refresh_token)
  FROM cofre.contaazul_secrets WHERE company_id = p_company_id;
$$;
REVOKE ALL ON FUNCTION public.get_contaazul_credentials(uuid) FROM public, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_contaazul_credentials(uuid) TO service_role;

CREATE OR REPLACE FUNCTION public.rotate_contaazul_refresh_token(p_company_id uuid, p_refresh_token text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, cofre AS $$
BEGIN
  IF coalesce(trim(p_refresh_token),'') = '' THEN RETURN; END IF;
  UPDATE cofre.contaazul_secrets SET refresh_token = p_refresh_token, updated_at = now() WHERE company_id = p_company_id;
END; $$;
REVOKE ALL ON FUNCTION public.rotate_contaazul_refresh_token(uuid, text) FROM public, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.rotate_contaazul_refresh_token(uuid, text) TO service_role;