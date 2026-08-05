-- ===== chart_of_accounts: campos que a tela usa =====
ALTER TABLE public.chart_of_accounts
  ADD COLUMN IF NOT EXISTS deducao boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS editable boolean NOT NULL DEFAULT true,
  ALTER COLUMN code DROP NOT NULL;

-- ===== WEBHOOKS =====
CREATE TABLE public.webhooks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  direction text NOT NULL DEFAULT 'inbound',
  url text,
  secret text NOT NULL DEFAULT encode(gen_random_bytes(24), 'hex'),
  events text[] NOT NULL DEFAULT '{}',
  auto_create_transaction boolean NOT NULL DEFAULT false,
  default_type text,
  default_account_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  default_cost_center_id uuid REFERENCES public.cost_centers(id) ON DELETE SET NULL,
  active boolean NOT NULL DEFAULT true,
  last_called_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.webhooks TO authenticated;
GRANT ALL ON public.webhooks TO service_role;
ALTER TABLE public.webhooks ENABLE ROW LEVEL SECURITY;
CREATE POLICY wh_sel ON public.webhooks FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY wh_ins ON public.webhooks FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY wh_upd ON public.webhooks FOR UPDATE TO authenticated USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY wh_del ON public.webhooks FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_webhooks_updated BEFORE UPDATE ON public.webhooks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE public.webhook_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_id uuid NOT NULL REFERENCES public.webhooks(id) ON DELETE CASCADE,
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  direction text NOT NULL DEFAULT 'inbound',
  event text,
  status_code integer,
  success boolean NOT NULL DEFAULT false,
  request_payload jsonb,
  response_body text,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_wh_logs ON public.webhook_logs (webhook_id, created_at DESC);
GRANT SELECT ON public.webhook_logs TO authenticated;
GRANT ALL ON public.webhook_logs TO service_role;
ALTER TABLE public.webhook_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY wh_log_sel ON public.webhook_logs FOR SELECT TO authenticated USING (public.is_company_admin(company_id));

-- ===== CONTABILIDADE / AUDITORIA =====
CREATE TABLE public.company_journal_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE CASCADE,
  date date NOT NULL,
  debit_account text,
  credit_account text,
  amount numeric NOT NULL DEFAULT 0,
  description text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_cje_company_date ON public.company_journal_entries (company_id, date DESC);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.company_journal_entries TO authenticated;
GRANT ALL ON public.company_journal_entries TO service_role;
ALTER TABLE public.company_journal_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY cje_sel ON public.company_journal_entries FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY cje_ins ON public.company_journal_entries FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY cje_upd ON public.company_journal_entries FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY cje_del ON public.company_journal_entries FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE TABLE public.reconciliation_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  kept_transaction_id uuid,
  removed_transaction_id uuid,
  decision text NOT NULL DEFAULT 'merge',
  resolved_by uuid,
  removed_snapshot jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_reclog_company ON public.reconciliation_log (company_id, created_at DESC);
GRANT SELECT, INSERT ON public.reconciliation_log TO authenticated;
GRANT ALL ON public.reconciliation_log TO service_role;
ALTER TABLE public.reconciliation_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY reclog_sel ON public.reconciliation_log FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY reclog_ins ON public.reconciliation_log FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));

-- ===== SÓCIO x EMPRESA =====
CREATE TABLE public.owner_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  user_id uuid NOT NULL DEFAULT auth.uid(),
  transaction_type text NOT NULL,
  amount numeric NOT NULL DEFAULT 0,
  date date NOT NULL DEFAULT current_date,
  description text,
  pj_bank_account_id uuid REFERENCES public.bank_accounts(id) ON DELETE SET NULL,
  pj_transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  status text NOT NULL DEFAULT 'confirmed',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_owner_tx ON public.owner_transactions (company_id, user_id, date DESC);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.owner_transactions TO authenticated;
GRANT ALL ON public.owner_transactions TO service_role;
ALTER TABLE public.owner_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY own_tx_sel ON public.owner_transactions FOR SELECT TO authenticated USING (user_id = auth.uid() AND public.is_company_member(company_id));
CREATE POLICY own_tx_ins ON public.owner_transactions FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid() AND public.can_write_company(company_id));
CREATE POLICY own_tx_upd ON public.owner_transactions FOR UPDATE TO authenticated USING (user_id = auth.uid() AND public.can_write_company(company_id)) WITH CHECK (user_id = auth.uid() AND public.can_write_company(company_id));
CREATE POLICY own_tx_del ON public.owner_transactions FOR DELETE TO authenticated USING (user_id = auth.uid() AND public.can_write_company(company_id));
CREATE TRIGGER trg_owner_tx_updated BEFORE UPDATE ON public.owner_transactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ===== METAS =====
CREATE TABLE public.kpi_metas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  metric_key text NOT NULL,
  alvo numeric NOT NULL DEFAULT 0,
  direcao text NOT NULL DEFAULT 'acima',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, metric_key)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.kpi_metas TO authenticated;
GRANT ALL ON public.kpi_metas TO service_role;
ALTER TABLE public.kpi_metas ENABLE ROW LEVEL SECURITY;
CREATE POLICY kpi_sel ON public.kpi_metas FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY kpi_ins ON public.kpi_metas FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY kpi_upd ON public.kpi_metas FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY kpi_del ON public.kpi_metas FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_kpi_metas_updated BEFORE UPDATE ON public.kpi_metas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ===== BLOCO 7: RELATÓRIOS CALCULADOS (views com security_invoker) =====
CREATE VIEW public.v_company_margin WITH (security_invoker = true) AS
SELECT t.company_id,
       date_trunc('month', coalesce(t.competencia_date, t.date))::date AS month,
       coalesce(sum(t.amount) FILTER (WHERE t.type = 'income' AND c.type = 'revenue'), 0) AS receita,
       coalesce(sum(t.amount) FILTER (WHERE t.type = 'expense' AND c.type = 'cost'), 0) AS custos,
       coalesce(sum(t.amount) FILTER (WHERE t.type = 'expense' AND c.type = 'expense'), 0) AS despesas
FROM public.transactions t
LEFT JOIN public.chart_of_accounts c ON c.id = t.account_id
WHERE t.status IN ('confirmed', 'reconciled')
GROUP BY 1, 2;
GRANT SELECT ON public.v_company_margin TO authenticated;

CREATE VIEW public.v_centro_custo_mes WITH (security_invoker = true) AS
SELECT t.company_id,
       date_trunc('month', coalesce(t.competencia_date, t.date))::date AS mes,
       cc.id AS centro_id,
       cc.name AS centro_nome,
       t.type,
       sum(t.amount) AS total
FROM public.transactions t
JOIN public.cost_centers cc ON cc.id = t.cost_center_id
WHERE t.status IN ('confirmed', 'reconciled')
GROUP BY 1, 2, 3, 4, 5;
GRANT SELECT ON public.v_centro_custo_mes TO authenticated;

CREATE VIEW public.v_cliente_360 WITH (security_invoker = true) AS
SELECT ct.company_id,
       ct.id AS contact_id,
       ct.name,
       ct.whatsapp,
       coalesce(sum(r.amount), 0) AS faturado,
       coalesce(sum(r.amount) FILTER (WHERE r.status = 'pending'), 0) AS em_aberto,
       max(r.due_date) AS ultima_cobranca
FROM public.contacts ct
LEFT JOIN public.receivables r ON r.contact_id = ct.id
GROUP BY 1, 2, 3, 4;
GRANT SELECT ON public.v_cliente_360 TO authenticated;

CREATE VIEW public.v_group_account_totals WITH (security_invoker = true) AS
SELECT t.company_id,
       date_trunc('month', coalesce(t.competencia_date, t.date))::date AS month,
       coalesce(c.group_code, 'sem_grupo') AS group_code,
       coalesce(c.group_name, 'Sem grupo') AS group_name,
       coalesce(c.type, 'expense') AS type,
       sum(t.amount) AS total
FROM public.transactions t
LEFT JOIN public.chart_of_accounts c ON c.id = t.account_id
WHERE t.status IN ('confirmed', 'reconciled')
GROUP BY 1, 2, 3, 4, 5;
GRANT SELECT ON public.v_group_account_totals TO authenticated;

CREATE VIEW public.v_dre_linhas WITH (security_invoker = true) AS
SELECT t.company_id,
       date_trunc('month', t.date)::date AS mes,
       date_trunc('month', coalesce(t.competencia_date, t.date))::date AS mes_competencia,
       c.id AS account_id,
       c.code AS account_code,
       c.name AS account_name,
       coalesce(c.type, 'expense') AS type,
       CASE
         WHEN c.deducao THEN 'deducao'
         WHEN c.type = 'revenue' THEN 'receita'
         WHEN c.type = 'cost' THEN 'custo'
         ELSE 'despesa'
       END AS grupo,
       sum(CASE WHEN t.type = 'income' THEN t.amount ELSE -t.amount END) AS total
FROM public.transactions t
LEFT JOIN public.chart_of_accounts c ON c.id = t.account_id
WHERE t.status IN ('confirmed', 'reconciled')
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8;
GRANT SELECT ON public.v_dre_linhas TO authenticated;

CREATE VIEW public.v_mrr_movimentos WITH (security_invoker = true) AS
WITH meses AS (
  SELECT c.company_id, generate_series(date_trunc('month', c.start_date),
         date_trunc('month', coalesce(c.end_date, current_date)), interval '1 month')::date AS mes,
         c.id, c.amount, c.start_date, c.end_date
  FROM public.contracts c
  WHERE c.status = 'active' OR c.end_date IS NOT NULL
)
SELECT company_id, mes,
       sum(amount) AS mrr_ativo,
       sum(amount) FILTER (WHERE date_trunc('month', start_date)::date = mes) AS mrr_novo,
       sum(amount) FILTER (WHERE date_trunc('month', end_date)::date = mes) AS mrr_perdido,
       count(*) FILTER (WHERE date_trunc('month', start_date)::date = mes) AS contratos_novos,
       count(*) FILTER (WHERE date_trunc('month', end_date)::date = mes) AS contratos_perdidos
FROM meses
GROUP BY 1, 2;
GRANT SELECT ON public.v_mrr_movimentos TO authenticated;

CREATE VIEW public.v_recompra_clientes WITH (security_invoker = true) AS
WITH base AS (
  SELECT ct.company_id, ct.id AS contact_id, ct.name, ct.whatsapp,
         count(r.id) AS n_compras,
         min(r.due_date) AS primeira_compra,
         max(r.due_date) AS ultima_compra,
         coalesce(sum(r.amount), 0) AS total_gasto,
         EXISTS (SELECT 1 FROM public.contracts k WHERE k.contact_id = ct.id AND k.status = 'active') AS tem_contrato
  FROM public.contacts ct
  JOIN public.receivables r ON r.contact_id = ct.id AND r.status IN ('paid', 'received', 'confirmed')
  GROUP BY 1, 2, 3, 4
)
SELECT company_id, contact_id, name, whatsapp, n_compras, primeira_compra, ultima_compra, total_gasto, tem_contrato,
       CASE WHEN n_compras > 0 THEN total_gasto / n_compras END AS ticket_medio,
       CASE WHEN n_compras > 1
            THEN (ultima_compra - primeira_compra)::numeric / (n_compras - 1) END AS intervalo_medio_dias,
       (current_date - ultima_compra) AS dias_desde_ultima,
       CASE WHEN n_compras > 1
            THEN ultima_compra + (((ultima_compra - primeira_compra) / (n_compras - 1))::int) END AS proxima_esperada
FROM base;
GRANT SELECT ON public.v_recompra_clientes TO authenticated;

CREATE VIEW public.v_stripe_repasses WITH (security_invoker = true) AS
SELECT p.company_id, p.config_id, cfg.apelido AS canal_nome, p.stripe_id, p.status,
       p.amount_bruto, p.amount_taxa, p.amount_liquido, p.itens, p.currency,
       p.arrival_date, p.composicao_fecha, p.diferenca, p.conciliado_at AS conciliado_em,
       p.transaction_id, p.created_at
FROM public.stripe_payouts p
LEFT JOIN public.stripe_config cfg ON cfg.id = p.config_id;
GRANT SELECT ON public.v_stripe_repasses TO authenticated;