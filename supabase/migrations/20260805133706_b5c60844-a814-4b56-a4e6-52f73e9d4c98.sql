-- ============ BLOCO 3: MOVIMENTO FINANCEIRO ============

CREATE TABLE public.transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  user_id uuid,
  date date NOT NULL DEFAULT current_date,
  competencia_date date,
  description text NOT NULL,
  amount numeric NOT NULL,
  type text NOT NULL CHECK (type IN ('revenue','expense','transfer')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','confirmed','reconciled','cancelled')),
  source text NOT NULL DEFAULT 'manual',
  account_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  cost_center_id uuid REFERENCES public.cost_centers(id) ON DELETE SET NULL,
  bank_account_id uuid REFERENCES public.bank_accounts(id) ON DELETE SET NULL,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  payment_method text,
  project text,
  attachment_url text,
  external_id text,
  confianca numeric,
  reconciled_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_tx_company_date ON public.transactions(company_id, date DESC);
CREATE INDEX idx_tx_status ON public.transactions(company_id, status);
CREATE UNIQUE INDEX idx_tx_external ON public.transactions(company_id, source, external_id) WHERE external_id IS NOT NULL;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.transactions TO authenticated;
GRANT ALL ON public.transactions TO service_role;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.transaction_allocations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id uuid NOT NULL REFERENCES public.transactions(id) ON DELETE CASCADE,
  cost_center_id uuid NOT NULL REFERENCES public.cost_centers(id) ON DELETE CASCADE,
  percentual numeric NOT NULL CHECK (percentual > 0 AND percentual <= 100),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (transaction_id, cost_center_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.transaction_allocations TO authenticated;
GRANT ALL ON public.transaction_allocations TO service_role;
ALTER TABLE public.transaction_allocations ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.receivables (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  contract_id uuid,
  description text NOT NULL,
  amount numeric NOT NULL,
  due_date date NOT NULL,
  status text NOT NULL DEFAULT 'a_receber' CHECK (status IN ('a_receber','recebido','vencido','cancelado')),
  source text NOT NULL DEFAULT 'manual',
  asaas_payment_id text,
  boleto_url text,
  pix_url text,
  stripe_checkout_url text,
  stripe_payment_intent_id text,
  payment_date date,
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  account_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  cost_center_id uuid REFERENCES public.cost_centers(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_recv_company_due ON public.receivables(company_id, due_date);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.receivables TO authenticated;
GRANT ALL ON public.receivables TO service_role;
ALTER TABLE public.receivables ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.bills_payable (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  fornecedor text NOT NULL,
  descricao text,
  valor numeric NOT NULL,
  vencimento date NOT NULL,
  status text NOT NULL DEFAULT 'pendente' CHECK (status IN ('pendente','a_vencer','vencido','pago','cancelado')),
  source text NOT NULL DEFAULT 'manual',
  approval_status text NOT NULL DEFAULT 'approved' CHECK (approval_status IN ('draft','awaiting_approval','approved','rejected')),
  requested_by uuid,
  approved_by uuid,
  approved_at timestamptz,
  is_recurring boolean DEFAULT false,
  recurrence_group_id uuid,
  recurrence_index integer,
  recurrence_total integer,
  transaction_id uuid REFERENCES public.transactions(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_bp_company_venc ON public.bills_payable(company_id, vencimento);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bills_payable TO authenticated;
GRANT ALL ON public.bills_payable TO service_role;
ALTER TABLE public.bills_payable ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.budgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  month date NOT NULL,
  receita numeric NOT NULL DEFAULT 0,
  custos numeric NOT NULL DEFAULT 0,
  despesas numeric NOT NULL DEFAULT 0,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, month)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.budgets TO authenticated;
GRANT ALL ON public.budgets TO service_role;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- ---------- politicas ----------
CREATE POLICY "ler lancamentos" ON public.transactions FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar lancamentos" ON public.transactions FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar lancamentos" ON public.transactions FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir lancamentos" ON public.transactions FOR DELETE TO authenticated USING (public.can_write_company(company_id));

CREATE POLICY "ler rateios" ON public.transaction_allocations FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.transactions t WHERE t.id = transaction_id AND public.is_company_member(t.company_id)));
CREATE POLICY "gravar rateios" ON public.transaction_allocations FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.transactions t WHERE t.id = transaction_id AND public.can_write_company(t.company_id)));
CREATE POLICY "editar rateios" ON public.transaction_allocations FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.transactions t WHERE t.id = transaction_id AND public.can_write_company(t.company_id)))
  WITH CHECK (EXISTS (SELECT 1 FROM public.transactions t WHERE t.id = transaction_id AND public.can_write_company(t.company_id)));
CREATE POLICY "excluir rateios" ON public.transaction_allocations FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.transactions t WHERE t.id = transaction_id AND public.can_write_company(t.company_id)));

CREATE POLICY "ler receber" ON public.receivables FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar receber" ON public.receivables FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar receber" ON public.receivables FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir receber" ON public.receivables FOR DELETE TO authenticated USING (public.can_write_company(company_id));

CREATE POLICY "ler pagar" ON public.bills_payable FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar pagar" ON public.bills_payable FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar pagar" ON public.bills_payable FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir pagar" ON public.bills_payable FOR DELETE TO authenticated USING (public.can_write_company(company_id));

CREATE POLICY "ler orcamento" ON public.budgets FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar orcamento" ON public.budgets FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar orcamento" ON public.budgets FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir orcamento" ON public.budgets FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE TRIGGER trg_tx_updated BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_recv_updated BEFORE UPDATE ON public.receivables FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_bp_updated BEFORE UPDATE ON public.bills_payable FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_budgets_updated BEFORE UPDATE ON public.budgets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
