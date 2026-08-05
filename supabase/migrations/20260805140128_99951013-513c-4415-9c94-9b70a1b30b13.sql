-- ============ BLOCO 6b-1 — ASAAS ============

-- CONFIGURAÇÃO (contém credenciais: leitura só de admin)
CREATE TABLE public.company_asaas_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL UNIQUE REFERENCES public.companies(id) ON DELETE CASCADE,
  environment text NOT NULL DEFAULT 'sandbox',
  api_key_sandbox text,
  api_key_production text,
  webhook_id text,
  webhook_url text,
  webhook_email text,
  webhook_status text NOT NULL DEFAULT 'not_configured',
  webhook_send_type text DEFAULT 'SEQUENTIALLY',
  webhook_auth_token text,
  notification_email text,
  enabled_events text[] NOT NULL DEFAULT '{}',
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_asaas_cfg_token ON public.company_asaas_config(webhook_auth_token);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.company_asaas_config TO authenticated;
GRANT ALL ON public.company_asaas_config TO service_role;
ALTER TABLE public.company_asaas_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "asaas_cfg_select" ON public.company_asaas_config FOR SELECT TO authenticated USING (public.is_company_admin(company_id));
CREATE POLICY "asaas_cfg_insert" ON public.company_asaas_config FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY "asaas_cfg_update" ON public.company_asaas_config FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY "asaas_cfg_delete" ON public.company_asaas_config FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_asaas_cfg_updated BEFORE UPDATE ON public.company_asaas_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- COBRANÇAS
CREATE TABLE public.company_asaas_payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  asaas_id text NOT NULL,
  customer_id text,
  subscription_id text,
  installment_id text,
  payment_link text,
  billing_type text,
  status text NOT NULL,
  value numeric(14,2),
  net_value numeric(14,2),
  description text,
  external_reference text,
  due_date date,
  payment_date date,
  confirmed_date date,
  credit_date date,
  invoice_url text,
  bank_slip_url text,
  pix_transaction jsonb,
  credit_card jsonb,
  discount jsonb,
  fine jsonb,
  interest jsonb,
  split jsonb,
  chargeback jsonb,
  refunds jsonb,
  raw_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, asaas_id)
);
CREATE TRIGGER trg_asaas_pay_updated BEFORE UPDATE ON public.company_asaas_payments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- CONTAS PAGAS (BILLS)
CREATE TABLE public.company_asaas_bills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  asaas_id text NOT NULL,
  status text NOT NULL,
  value numeric(14,2),
  fee numeric(14,2),
  description text,
  company_name text,
  identification_field text,
  type text,
  due_date date,
  schedule_date date,
  payment_date date,
  can_be_cancelled boolean,
  failure_reason text,
  raw_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, asaas_id)
);
CREATE TRIGGER trg_asaas_bill_updated BEFORE UPDATE ON public.company_asaas_bills FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- NOTAS FISCAIS DO ASAAS
CREATE TABLE public.company_asaas_invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  asaas_id text NOT NULL,
  payment_id text,
  status text NOT NULL,
  number text,
  service_description text,
  value numeric(14,2),
  net_value numeric(14,2),
  observations text,
  taxes jsonb,
  customer_id text,
  effective_date date,
  pdf_url text,
  xml_url text,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, asaas_id)
);
CREATE TRIGGER trg_asaas_inv_updated BEFORE UPDATE ON public.company_asaas_invoices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ASSINATURAS
CREATE TABLE public.company_asaas_subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  asaas_id text NOT NULL,
  customer_id text,
  billing_type text,
  status text NOT NULL,
  value numeric(14,2),
  next_due_date date,
  cycle text,
  description text,
  max_payments integer,
  payment_count integer,
  external_reference text,
  end_date date,
  raw_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, asaas_id)
);
CREATE TRIGGER trg_asaas_sub_updated BEFORE UPDATE ON public.company_asaas_subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- TRANSFERÊNCIAS
CREATE TABLE public.company_asaas_transfers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  asaas_id text NOT NULL,
  type text,
  status text NOT NULL,
  value numeric(14,2),
  net_value numeric(14,2),
  fee numeric(14,2),
  transfer_fee numeric(14,2),
  description text,
  bank_account jsonb,
  scheduled_date date,
  transaction_receipt_url text,
  authorized boolean,
  operation_type text,
  external_reference text,
  raw_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, asaas_id)
);
CREATE TRIGGER trg_asaas_trf_updated BEFORE UPDATE ON public.company_asaas_transfers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ANTECIPAÇÕES
CREATE TABLE public.company_asaas_anticipations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  asaas_id text NOT NULL,
  status text NOT NULL,
  anticipated_value numeric(14,2),
  net_value numeric(14,2),
  fee numeric(14,2),
  total_value numeric(14,2),
  installment_count integer,
  payment_id text,
  anticipation_date date,
  credit_date date,
  debit_date date,
  due_date date,
  denial_reason text,
  raw_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, asaas_id)
);
CREATE TRIGGER trg_asaas_ant_updated BEFORE UPDATE ON public.company_asaas_anticipations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- EVENTOS DE WEBHOOK
CREATE TABLE public.company_asaas_webhook_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  event_id text NOT NULL,
  event_type text NOT NULL,
  event_category text,
  entity_id text,
  entity_type text,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  processed boolean NOT NULL DEFAULT false,
  processed_at timestamptz,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, event_id)
);

-- GRANTS + RLS PADRÃO PARA AS TABELAS DE DADOS SINCRONIZADOS
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'company_asaas_payments','company_asaas_bills','company_asaas_invoices',
    'company_asaas_subscriptions','company_asaas_transfers','company_asaas_anticipations',
    'company_asaas_webhook_events'
  ] LOOP
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON public.%I TO authenticated', t);
    EXECUTE format('GRANT ALL ON public.%I TO service_role', t);
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('CREATE POLICY "%s_select" ON public.%I FOR SELECT TO authenticated USING (public.is_company_member(company_id))', t, t);
    EXECUTE format('CREATE POLICY "%s_insert" ON public.%I FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id))', t, t);
    EXECUTE format('CREATE POLICY "%s_update" ON public.%I FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id))', t, t);
    EXECUTE format('CREATE POLICY "%s_delete" ON public.%I FOR DELETE TO authenticated USING (public.is_company_admin(company_id))', t, t);
  END LOOP;
END $$;