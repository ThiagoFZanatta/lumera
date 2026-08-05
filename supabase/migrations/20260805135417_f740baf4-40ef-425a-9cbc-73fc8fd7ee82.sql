-- ================= INVOICES =================
CREATE TABLE public.invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  sales_order_id uuid REFERENCES public.sales_orders(id) ON DELETE SET NULL,
  type text NOT NULL DEFAULT 'nfe',
  status text NOT NULL DEFAULT 'processing',
  number text,
  series text,
  access_key text,
  issue_date date NOT NULL DEFAULT current_date,
  total numeric NOT NULL DEFAULT 0,
  notes text,
  xml_content text,
  pdf_url text,
  cbs_valor numeric,
  ibs_valor numeric,
  cclasstrib text,
  cancelled_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.invoices TO authenticated;
GRANT ALL ON public.invoices TO service_role;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "invoices_select" ON public.invoices FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "invoices_insert" ON public.invoices FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "invoices_update" ON public.invoices FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "invoices_delete" ON public.invoices FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_invoices_updated BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_invoices_company ON public.invoices(company_id);

-- ================= TAX GUIDES =================
CREATE TABLE public.tax_guides (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  tipo text NOT NULL,
  competencia text NOT NULL,
  vencimento date NOT NULL,
  valor numeric NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'a_pagar',
  source text NOT NULL DEFAULT 'manual',
  invoice_id uuid REFERENCES public.invoices(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.tax_guides TO authenticated;
GRANT ALL ON public.tax_guides TO service_role;
ALTER TABLE public.tax_guides ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tax_guides_select" ON public.tax_guides FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "tax_guides_insert" ON public.tax_guides FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "tax_guides_update" ON public.tax_guides FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "tax_guides_delete" ON public.tax_guides FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_tax_guides_updated BEFORE UPDATE ON public.tax_guides FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_tax_guides_company ON public.tax_guides(company_id);

-- ================= FISCAL FILES =================
CREATE TABLE public.fiscal_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  nome text NOT NULL,
  tipo text NOT NULL,
  file_url text,
  file_size text,
  source text NOT NULL DEFAULT 'manual',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.fiscal_files TO authenticated;
GRANT ALL ON public.fiscal_files TO service_role;
ALTER TABLE public.fiscal_files ENABLE ROW LEVEL SECURITY;
CREATE POLICY "fiscal_files_select" ON public.fiscal_files FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "fiscal_files_insert" ON public.fiscal_files FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "fiscal_files_update" ON public.fiscal_files FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "fiscal_files_delete" ON public.fiscal_files FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_fiscal_files_updated BEFORE UPDATE ON public.fiscal_files FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_fiscal_files_company ON public.fiscal_files(company_id);

-- ================= PLUGNOTAS CONFIG =================
CREATE TABLE public.plugnotas_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL UNIQUE REFERENCES public.companies(id) ON DELETE CASCADE,
  api_key text,
  api_key_set boolean GENERATED ALWAYS AS (nullif(api_key, '') IS NOT NULL) STORED,
  environment text NOT NULL DEFAULT 'sandbox',
  plugnotas_empresa_cnpj text,
  plugnotas_empresa_id text,
  enabled_nfe boolean NOT NULL DEFAULT false,
  enabled_nfse boolean NOT NULL DEFAULT false,
  enabled_nfce boolean NOT NULL DEFAULT false,
  enabled_cte boolean NOT NULL DEFAULT false,
  enabled_mdfe boolean NOT NULL DEFAULT false,
  serie_padrao text NOT NULL DEFAULT '1',
  active boolean NOT NULL DEFAULT true,
  last_test_at timestamptz,
  last_test_status text,
  last_emission_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT ALL ON public.plugnotas_config TO service_role;
GRANT SELECT (id, company_id, api_key_set, environment, plugnotas_empresa_cnpj, plugnotas_empresa_id,
              enabled_nfe, enabled_nfse, enabled_nfce, enabled_cte, enabled_mdfe, serie_padrao, active,
              last_test_at, last_test_status, last_emission_at, created_at, updated_at)
  ON public.plugnotas_config TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.plugnotas_config TO authenticated;
ALTER TABLE public.plugnotas_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "plugnotas_config_select" ON public.plugnotas_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "plugnotas_config_write" ON public.plugnotas_config FOR ALL TO authenticated
  USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE TRIGGER trg_plugnotas_config_updated BEFORE UPDATE ON public.plugnotas_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ================= PLUGNOTAS DOCUMENTS =================
CREATE TABLE public.plugnotas_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  doc_type text NOT NULL,
  plugnotas_id text,
  chave_acesso text,
  numero text,
  serie text,
  status text NOT NULL,
  status_message text,
  payload_request jsonb,
  payload_response jsonb,
  invoice_id uuid REFERENCES public.invoices(id) ON DELETE SET NULL,
  cbs_valor numeric,
  ibs_valor numeric,
  cbs_aliquota numeric,
  ibs_aliquota numeric,
  cclasstrib text,
  emitted_at timestamptz,
  cancelled_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.plugnotas_documents TO authenticated;
GRANT ALL ON public.plugnotas_documents TO service_role;
ALTER TABLE public.plugnotas_documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "plugnotas_documents_select" ON public.plugnotas_documents FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE TRIGGER trg_plugnotas_documents_updated BEFORE UPDATE ON public.plugnotas_documents FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_plugnotas_docs_company ON public.plugnotas_documents(company_id);

-- ================= FOCUS CONFIG =================
CREATE TABLE public.focus_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL UNIQUE REFERENCES public.companies(id) ON DELETE CASCADE,
  environment text NOT NULL DEFAULT 'homologacao',
  token_homologacao text,
  token_producao text,
  token_homologacao_preview text,
  token_producao_preview text,
  active boolean NOT NULL DEFAULT false,
  last_test_at timestamptz,
  last_test_status text,
  last_emission_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT ALL ON public.focus_config TO service_role;
GRANT SELECT (id, company_id, environment, token_homologacao_preview, token_producao_preview, active,
              last_test_at, last_test_status, last_emission_at, created_at, updated_at)
  ON public.focus_config TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.focus_config TO authenticated;
ALTER TABLE public.focus_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "focus_config_select" ON public.focus_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "focus_config_write" ON public.focus_config FOR ALL TO authenticated
  USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE TRIGGER trg_focus_config_updated BEFORE UPDATE ON public.focus_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE OR REPLACE FUNCTION public.set_focus_token(p_company_id uuid, p_environment text, p_token text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE v_preview text;
BEGIN
  IF NOT public.is_company_admin(p_company_id) THEN RAISE EXCEPTION 'Sem permissao'; END IF;
  IF coalesce(trim(p_token), '') = '' THEN RAISE EXCEPTION 'Token vazio'; END IF;
  IF p_environment NOT IN ('homologacao','producao') THEN RAISE EXCEPTION 'Ambiente invalido'; END IF;
  v_preview := repeat('*', greatest(length(p_token) - 4, 0)) || right(p_token, 4);

  INSERT INTO public.focus_config (company_id, environment, active)
  VALUES (p_company_id, p_environment, true)
  ON CONFLICT (company_id) DO UPDATE SET environment = excluded.environment, active = true;

  IF p_environment = 'homologacao' THEN
    UPDATE public.focus_config SET token_homologacao = p_token, token_homologacao_preview = v_preview
    WHERE company_id = p_company_id;
  ELSE
    UPDATE public.focus_config SET token_producao = p_token, token_producao_preview = v_preview
    WHERE company_id = p_company_id;
  END IF;
END; $$;
REVOKE EXECUTE ON FUNCTION public.set_focus_token(uuid, text, text) FROM public, anon;
GRANT EXECUTE ON FUNCTION public.set_focus_token(uuid, text, text) TO authenticated;

-- ================= NFSE CONFIG =================
CREATE TABLE public.nfse_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL UNIQUE REFERENCES public.companies(id) ON DELETE CASCADE,
  cert_pfx_base64 text,
  cert_password text,
  cert_set boolean GENERATED ALWAYS AS (nullif(cert_pfx_base64, '') IS NOT NULL) STORED,
  ambiente text NOT NULL DEFAULT 'homologacao',
  serie_dps text NOT NULL DEFAULT '1',
  proximo_numero_dps integer NOT NULL DEFAULT 1,
  codigo_municipio text,
  inscricao_municipal text,
  active boolean NOT NULL DEFAULT false,
  last_test_at timestamptz,
  last_test_status text,
  last_emission_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT ALL ON public.nfse_config TO service_role;
GRANT SELECT (id, company_id, cert_set, ambiente, serie_dps, proximo_numero_dps, codigo_municipio,
              inscricao_municipal, active, last_test_at, last_test_status, last_emission_at, created_at, updated_at)
  ON public.nfse_config TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.nfse_config TO authenticated;
ALTER TABLE public.nfse_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "nfse_config_select" ON public.nfse_config FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "nfse_config_write" ON public.nfse_config FOR ALL TO authenticated
  USING (public.is_company_admin(company_id)) WITH CHECK (public.is_company_admin(company_id));
CREATE TRIGGER trg_nfse_config_updated BEFORE UPDATE ON public.nfse_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ================= TABELAS DE APOIO =================
CREATE TABLE public.tax_rates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tax text NOT NULL,
  ente_code text NOT NULL,
  item_code text,
  rate numeric NOT NULL,
  vigencia_inicio date,
  vigencia_fim date,
  source text,
  version text,
  confidence text,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.tax_rates TO authenticated;
GRANT ALL ON public.tax_rates TO service_role;
ALTER TABLE public.tax_rates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tax_rates_select" ON public.tax_rates FOR SELECT TO authenticated USING (true);

CREATE TABLE public.cclasstrib_codigos (
  codigo text PRIMARY KEY,
  descricao text NOT NULL,
  tributo text,
  ativo boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.cclasstrib_codigos TO authenticated;
GRANT ALL ON public.cclasstrib_codigos TO service_role;
ALTER TABLE public.cclasstrib_codigos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cclasstrib_select" ON public.cclasstrib_codigos FOR SELECT TO authenticated USING (true);

CREATE TABLE public.municipalities (
  code_ibge text PRIMARY KEY,
  name text NOT NULL,
  uf text,
  region text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.municipalities TO authenticated;
GRANT ALL ON public.municipalities TO service_role;
ALTER TABLE public.municipalities ENABLE ROW LEVEL SECURITY;
CREATE POLICY "municipalities_select" ON public.municipalities FOR SELECT TO authenticated USING (true);

-- ================= MONTHLY CLOSE =================
CREATE TABLE public.monthly_close (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  month date NOT NULL,
  status text NOT NULL DEFAULT 'open',
  snapshot jsonb,
  closed_at timestamptz,
  closed_by uuid,
  reopened_at timestamptz,
  reopened_by uuid,
  reopen_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, month)
);
GRANT SELECT ON public.monthly_close TO authenticated;
GRANT ALL ON public.monthly_close TO service_role;
ALTER TABLE public.monthly_close ENABLE ROW LEVEL SECURITY;
CREATE POLICY "monthly_close_select" ON public.monthly_close FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE TRIGGER trg_monthly_close_updated BEFORE UPDATE ON public.monthly_close FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE OR REPLACE FUNCTION public.fechar_mes(p_company_id uuid, p_mes date)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_mes date := date_trunc('month', p_mes)::date;
  v_rec numeric := 0; v_cus numeric := 0; v_des numeric := 0; v_sem numeric := 0;
  v_snap jsonb;
BEGIN
  IF NOT public.is_company_admin(p_company_id) THEN RAISE EXCEPTION 'Somente administrador pode fechar o mes'; END IF;

  SELECT
    coalesce(sum(t.amount) FILTER (WHERE t.type = 'income' AND c.type = 'revenue'), 0),
    coalesce(sum(t.amount) FILTER (WHERE t.type = 'expense' AND c.type = 'cost'), 0),
    coalesce(sum(t.amount) FILTER (WHERE t.type = 'expense' AND c.type = 'expense'), 0),
    coalesce(sum(t.amount) FILTER (WHERE t.account_id IS NULL), 0)
  INTO v_rec, v_cus, v_des, v_sem
  FROM public.transactions t
  LEFT JOIN public.chart_of_accounts c ON c.id = t.account_id
  WHERE t.company_id = p_company_id
    AND t.status = 'confirmed'
    AND date_trunc('month', coalesce(t.competencia_date, t.date))::date = v_mes;

  v_snap := jsonb_build_object(
    'receita', v_rec, 'custos', v_cus, 'despesas', v_des,
    'lucro_liquido', v_rec - v_cus - v_des, 'a_classificar', v_sem
  );

  INSERT INTO public.monthly_close (company_id, month, status, snapshot, closed_at, closed_by)
  VALUES (p_company_id, v_mes, 'closed', v_snap, now(), auth.uid())
  ON CONFLICT (company_id, month) DO UPDATE
    SET status = 'closed', snapshot = v_snap, closed_at = now(), closed_by = auth.uid(),
        reopened_at = NULL, reopened_by = NULL, reopen_reason = NULL;

  RETURN v_snap;
END; $$;
REVOKE EXECUTE ON FUNCTION public.fechar_mes(uuid, date) FROM public, anon;
GRANT EXECUTE ON FUNCTION public.fechar_mes(uuid, date) TO authenticated;

CREATE OR REPLACE FUNCTION public.reabrir_mes(p_company_id uuid, p_mes date, p_motivo text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE v_mes date := date_trunc('month', p_mes)::date;
BEGIN
  IF NOT public.is_company_admin(p_company_id) THEN RAISE EXCEPTION 'Somente administrador pode reabrir o mes'; END IF;
  IF coalesce(trim(p_motivo), '') = '' THEN RAISE EXCEPTION 'Informe o motivo da reabertura'; END IF;
  UPDATE public.monthly_close
     SET status = 'open', reopened_at = now(), reopened_by = auth.uid(), reopen_reason = trim(p_motivo)
   WHERE company_id = p_company_id AND month = v_mes;
END; $$;
REVOKE EXECUTE ON FUNCTION public.reabrir_mes(uuid, date, text) FROM public, anon;
GRANT EXECUTE ON FUNCTION public.reabrir_mes(uuid, date, text) TO authenticated;

-- ================= STORAGE: politicas do bucket documents =================
CREATE POLICY "documents_select" ON storage.objects FOR SELECT TO authenticated
  USING (bucket_id = 'documents' AND public.is_company_member(((storage.foldername(name))[1])::uuid));
CREATE POLICY "documents_insert" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'documents' AND public.can_write_company(((storage.foldername(name))[1])::uuid));
CREATE POLICY "documents_update" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'documents' AND public.can_write_company(((storage.foldername(name))[1])::uuid));
CREATE POLICY "documents_delete" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'documents' AND public.is_company_admin(((storage.foldername(name))[1])::uuid));