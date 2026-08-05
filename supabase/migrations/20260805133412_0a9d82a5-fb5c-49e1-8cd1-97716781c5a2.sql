-- ============ BLOCO 2: CADASTROS BASE ============

CREATE OR REPLACE FUNCTION public.can_write_company(_company_id uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.company_members m
                 WHERE m.company_id = _company_id AND m.user_id = auth.uid()
                   AND m.role IN ('admin','member'));
$$;
REVOKE ALL ON FUNCTION public.can_write_company(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_write_company(uuid) TO authenticated, service_role;

-- ---------- chart_of_accounts ----------
CREATE TABLE public.chart_of_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  code text NOT NULL,
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('revenue','expense','asset','liability','equity')),
  parent_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  group_code text,
  group_name text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, code)
);
CREATE INDEX idx_coa_company ON public.chart_of_accounts(company_id);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.chart_of_accounts TO authenticated;
GRANT ALL ON public.chart_of_accounts TO service_role;
ALTER TABLE public.chart_of_accounts ENABLE ROW LEVEL SECURITY;

-- ---------- cost_centers ----------
CREATE TABLE public.cost_centers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  category text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_cc_company ON public.cost_centers(company_id);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cost_centers TO authenticated;
GRANT ALL ON public.cost_centers TO service_role;
ALTER TABLE public.cost_centers ENABLE ROW LEVEL SECURITY;

-- ---------- contacts ----------
CREATE TABLE public.contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  trade_name text,
  type text NOT NULL DEFAULT 'customer' CHECK (type IN ('customer','supplier','both')),
  person_type text CHECK (person_type IN ('pf','pj')),
  document text,
  state_registration text,
  email text,
  phone text,
  whatsapp text,
  website text,
  zip_code text,
  street text,
  number text,
  complement text,
  neighborhood text,
  city text,
  state text,
  default_payment_terms integer,
  credit_limit numeric,
  notes text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_contacts_company ON public.contacts(company_id);
CREATE INDEX idx_contacts_doc ON public.contacts(company_id, document);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.contacts TO authenticated;
GRANT ALL ON public.contacts TO service_role;
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

-- ---------- bank_accounts ----------
CREATE TABLE public.bank_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  bank_name text,
  bank_code text,
  agency text,
  account_number text,
  account_type text NOT NULL DEFAULT 'checking' CHECK (account_type IN ('checking','savings','investment','cash')),
  balance numeric NOT NULL DEFAULT 0,
  active boolean NOT NULL DEFAULT true,
  last_synced_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_bank_accounts_company ON public.bank_accounts(company_id);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bank_accounts TO authenticated;
GRANT ALL ON public.bank_accounts TO service_role;
ALTER TABLE public.bank_accounts ENABLE ROW LEVEL SECURITY;

-- ---------- politicas (mesmo padrao nas 4 tabelas) ----------
CREATE POLICY "ler contas" ON public.chart_of_accounts FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar contas" ON public.chart_of_accounts FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar contas" ON public.chart_of_accounts FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir contas" ON public.chart_of_accounts FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE POLICY "ler centros" ON public.cost_centers FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar centros" ON public.cost_centers FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar centros" ON public.cost_centers FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir centros" ON public.cost_centers FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE POLICY "ler contatos" ON public.contacts FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar contatos" ON public.contacts FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar contatos" ON public.contacts FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir contatos" ON public.contacts FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE POLICY "ler bancos" ON public.bank_accounts FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "criar bancos" ON public.bank_accounts FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "editar bancos" ON public.bank_accounts FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "excluir bancos" ON public.bank_accounts FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE TRIGGER trg_coa_updated BEFORE UPDATE ON public.chart_of_accounts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_cc_updated BEFORE UPDATE ON public.cost_centers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_contacts_updated BEFORE UPDATE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_bank_accounts_updated BEFORE UPDATE ON public.bank_accounts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
