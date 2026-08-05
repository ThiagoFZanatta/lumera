-- ============ BLOCO 6b-2 — STRIPE ============

-- Cofre interno: schema fora da API. Nenhum papel do PostgREST enxerga.
CREATE SCHEMA IF NOT EXISTS cofre;
REVOKE ALL ON SCHEMA cofre FROM PUBLIC;

CREATE TABLE public.stripe_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  apelido text NOT NULL DEFAULT 'Principal',
  mode text NOT NULL DEFAULT 'test',
  publishable_key text,
  secret_key_preview text,
  webhook_secret_preview text,
  conta_taxa_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  centro_custo_taxa_id uuid REFERENCES public.cost_centers(id) ON DELETE SET NULL,
  last_test_at timestamptz,
  last_test_status text,
  last_sync_at timestamptz,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, apelido)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.stripe_config TO authenticated;
GRANT ALL ON public.stripe_config TO service_role;
ALTER TABLE public.stripe_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "stripe_cfg_select" ON public.stripe_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "stripe_cfg_insert" ON public.stripe_config FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY "stripe_cfg_update" ON public.stripe_config FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY "stripe_cfg_delete" ON public.stripe_config FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_stripe_cfg_updated BEFORE UPDATE ON public.stripe_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Segredos do canal (fora do schema exposto)
CREATE TABLE cofre.stripe_secrets (
  config_id uuid PRIMARY KEY REFERENCES public.stripe_config(id) ON DELETE CASCADE,
  secret_key text,
  webhook_secret text,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- COBRANÇAS
CREATE TABLE public.stripe_charges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  config_id uuid NOT NULL REFERENCES public.stripe_config(id) ON DELETE CASCADE,
  stripe_id text NOT NULL,
  balance_transaction_id text,
  payout_id text,
  status text,
  amount_bruto bigint NOT NULL DEFAULT 0,
  amount_taxa bigint NOT NULL DEFAULT 0,
  amount_liquido bigint NOT NULL DEFAULT 0,
  currency text NOT NULL DEFAULT 'brl',
  description text,
  customer_email text,
  paid_at timestamptz,
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  receivable_id uuid REFERENCES public.receivables(id) ON DELETE SET NULL,
  raw jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (config_id, stripe_id)
);
CREATE INDEX idx_stripe_charges_payout ON public.stripe_charges(company_id, payout_id);
CREATE TRIGGER trg_stripe_charges_updated BEFORE UPDATE ON public.stripe_charges FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- REPASSES
CREATE TABLE public.stripe_payouts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  config_id uuid NOT NULL REFERENCES public.stripe_config(id) ON DELETE CASCADE,
  stripe_id text NOT NULL,
  status text,
  amount_bruto bigint NOT NULL DEFAULT 0,
  amount_taxa bigint NOT NULL DEFAULT 0,
  amount_liquido bigint NOT NULL DEFAULT 0,
  itens integer NOT NULL DEFAULT 0,
  currency text NOT NULL DEFAULT 'brl',
  arrival_date date,
  composicao_fecha boolean,
  diferenca bigint,
  conciliado_at timestamptz,
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  raw jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (config_id, stripe_id)
);
CREATE TRIGGER trg_stripe_payouts_updated BEFORE UPDATE ON public.stripe_payouts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- EVENTOS (idempotência)
CREATE TABLE public.stripe_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  stripe_event_id text NOT NULL UNIQUE,
  type text,
  raw jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['stripe_charges','stripe_payouts','stripe_events'] LOOP
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON public.%I TO authenticated', t);
    EXECUTE format('GRANT ALL ON public.%I TO service_role', t);
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('CREATE POLICY "%s_select" ON public.%I FOR SELECT TO authenticated USING (public.is_company_member(company_id))', t, t);
    EXECUTE format('CREATE POLICY "%s_insert" ON public.%I FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id))', t, t);
    EXECUTE format('CREATE POLICY "%s_update" ON public.%I FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id))', t, t);
    EXECUTE format('CREATE POLICY "%s_delete" ON public.%I FOR DELETE TO authenticated USING (public.is_company_admin(company_id))', t, t);
  END LOOP;
END $$;

-- ── ROTINAS ──────────────────────────────────────────────────────────────
-- Guarda a credencial no cofre. Só admin da empresa pode.
CREATE OR REPLACE FUNCTION public.set_stripe_credentials(
  p_company_id uuid,
  p_secret_key text,
  p_webhook_secret text,
  p_publishable_key text,
  p_mode text,
  p_apelido text
) RETURNS uuid
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, cofre
AS $$
DECLARE v_id uuid;
BEGIN
  IF NOT public.is_company_admin(p_company_id) THEN
    RAISE EXCEPTION 'Somente administrador da empresa pode configurar o Stripe';
  END IF;

  INSERT INTO public.stripe_config (company_id, apelido, mode, publishable_key)
  VALUES (p_company_id, coalesce(nullif(trim(p_apelido), ''), 'Principal'),
          CASE WHEN p_mode = 'live' THEN 'live' ELSE 'test' END,
          nullif(p_publishable_key, ''))
  ON CONFLICT (company_id, apelido) DO UPDATE
    SET mode = EXCLUDED.mode,
        publishable_key = coalesce(EXCLUDED.publishable_key, public.stripe_config.publishable_key)
  RETURNING id INTO v_id;

  UPDATE public.stripe_config SET
    secret_key_preview = CASE WHEN nullif(p_secret_key,'') IS NULL THEN secret_key_preview
                              ELSE left(p_secret_key, 7) || '...' || right(p_secret_key, 4) END,
    webhook_secret_preview = CASE WHEN nullif(p_webhook_secret,'') IS NULL THEN webhook_secret_preview
                                  ELSE left(p_webhook_secret, 7) || '...' END
  WHERE id = v_id;

  INSERT INTO cofre.stripe_secrets (config_id, secret_key, webhook_secret)
  VALUES (v_id, nullif(p_secret_key, ''), nullif(p_webhook_secret, ''))
  ON CONFLICT (config_id) DO UPDATE SET
    secret_key = coalesce(nullif(EXCLUDED.secret_key, ''), cofre.stripe_secrets.secret_key),
    webhook_secret = coalesce(nullif(EXCLUDED.webhook_secret, ''), cofre.stripe_secrets.webhook_secret),
    updated_at = now();

  RETURN v_id;
END; $$;
REVOKE ALL ON FUNCTION public.set_stripe_credentials(uuid, text, text, text, text, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_stripe_credentials(uuid, text, text, text, text, text) TO authenticated;

-- Leitura da credencial: EXCLUSIVA do servidor (service_role).
CREATE OR REPLACE FUNCTION public.get_stripe_credentials(p_config_id uuid)
RETURNS jsonb
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public, cofre
AS $$
  SELECT jsonb_build_object(
    'company_id', c.company_id,
    'apelido', c.apelido,
    'mode', c.mode,
    'secret_key', s.secret_key,
    'webhook_secret', s.webhook_secret
  )
  FROM public.stripe_config c
  LEFT JOIN cofre.stripe_secrets s ON s.config_id = c.id
  WHERE c.id = p_config_id;
$$;
REVOKE ALL ON FUNCTION public.get_stripe_credentials(uuid) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_stripe_credentials(uuid) TO service_role;

-- Canal único da empresa (nulo quando há mais de um)
CREATE OR REPLACE FUNCTION public.resolver_canal_stripe_unico(p_company_id uuid)
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT CASE WHEN count(*) = 1 THEN (array_agg(id))[1] ELSE NULL END
  FROM public.stripe_config WHERE company_id = p_company_id;
$$;
REVOKE ALL ON FUNCTION public.resolver_canal_stripe_unico(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.resolver_canal_stripe_unico(uuid) TO authenticated, service_role;