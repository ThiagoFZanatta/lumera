-- ============ BLOCO 6a — AGENTES DE IA, AVISOS E APRENDIZADO ============

-- 1) REGRAS DOS AGENTES NATIVOS (cobrança, anomalias)
CREATE TABLE public.agent_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  agent text NOT NULL,
  ativo boolean NOT NULL DEFAULT true,
  config jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, agent)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_rules TO authenticated;
GRANT ALL ON public.agent_rules TO service_role;
ALTER TABLE public.agent_rules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "agent_rules_select" ON public.agent_rules FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "agent_rules_insert" ON public.agent_rules FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "agent_rules_update" ON public.agent_rules FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "agent_rules_delete" ON public.agent_rules FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_agent_rules_updated BEFORE UPDATE ON public.agent_rules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 2) INSTÂNCIAS DE AGENTES DO CATÁLOGO
CREATE TABLE public.agent_instances (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  template_key text NOT NULL,
  nome text NOT NULL,
  ativo boolean NOT NULL DEFAULT true,
  config jsonb NOT NULL DEFAULT '{}'::jsonb,
  canais jsonb NOT NULL DEFAULT '{"inapp": true}'::jsonb,
  last_run_at timestamptz,
  last_result jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_agent_instances_company ON public.agent_instances(company_id);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_instances TO authenticated;
GRANT ALL ON public.agent_instances TO service_role;
ALTER TABLE public.agent_instances ENABLE ROW LEVEL SECURITY;
CREATE POLICY "agent_instances_select" ON public.agent_instances FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "agent_instances_insert" ON public.agent_instances FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "agent_instances_update" ON public.agent_instances FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "agent_instances_delete" ON public.agent_instances FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_agent_instances_updated BEFORE UPDATE ON public.agent_instances FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 3) AÇÕES PROPOSTAS PELOS AGENTES
CREATE TABLE public.agent_actions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  agent text NOT NULL,
  action_type text NOT NULL,
  title text NOT NULL,
  description text,
  suggested_message text,
  amount numeric(14,2),
  due_date date,
  contact_name text,
  contact_whatsapp text,
  status text NOT NULL DEFAULT 'pending',
  dedupe_key text,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  decided_at timestamptz,
  decided_by uuid,
  executed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX idx_agent_actions_dedupe ON public.agent_actions(company_id, dedupe_key) WHERE dedupe_key IS NOT NULL;
CREATE INDEX idx_agent_actions_company_status ON public.agent_actions(company_id, status);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_actions TO authenticated;
GRANT ALL ON public.agent_actions TO service_role;
ALTER TABLE public.agent_actions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "agent_actions_select" ON public.agent_actions FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "agent_actions_insert" ON public.agent_actions FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "agent_actions_update" ON public.agent_actions FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "agent_actions_delete" ON public.agent_actions FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_agent_actions_updated BEFORE UPDATE ON public.agent_actions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 4) NOTIFICAÇÕES INTERNAS
CREATE TABLE public.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  titulo text NOT NULL,
  corpo text,
  categoria text NOT NULL DEFAULT 'geral',
  link text,
  lida boolean NOT NULL DEFAULT false,
  dedupe_key text,
  agent_instance_id uuid REFERENCES public.agent_instances(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX idx_notifications_dedupe ON public.notifications(company_id, dedupe_key) WHERE dedupe_key IS NOT NULL;
CREATE INDEX idx_notifications_company_created ON public.notifications(company_id, created_at DESC);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO authenticated;
GRANT ALL ON public.notifications TO service_role;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "notifications_select" ON public.notifications FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "notifications_insert" ON public.notifications FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "notifications_update" ON public.notifications FOR UPDATE TO authenticated USING (public.is_company_member(company_id)) WITH CHECK (public.is_company_member(company_id));
CREATE POLICY "notifications_delete" ON public.notifications FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

-- 5) REGRAS DE CLASSIFICAÇÃO APRENDIDAS
CREATE TABLE public.classification_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  padrao text NOT NULL,
  account_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  cost_center_id uuid REFERENCES public.cost_centers(id) ON DELETE SET NULL,
  acertos integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, padrao)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.classification_rules TO authenticated;
GRANT ALL ON public.classification_rules TO service_role;
ALTER TABLE public.classification_rules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "classification_rules_select" ON public.classification_rules FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "classification_rules_insert" ON public.classification_rules FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "classification_rules_update" ON public.classification_rules FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "classification_rules_delete" ON public.classification_rules FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_classification_rules_updated BEFORE UPDATE ON public.classification_rules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 6) CONSUMO DE IA (custo) — só admin lê; escrita é do backend
CREATE TABLE public.ai_usage (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid REFERENCES public.companies(id) ON DELETE CASCADE,
  funcao text NOT NULL,
  modelo text,
  prompt_tokens integer NOT NULL DEFAULT 0,
  completion_tokens integer NOT NULL DEFAULT 0,
  custo_centavos numeric(12,4) NOT NULL DEFAULT 0,
  sucesso boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_ai_usage_company_created ON public.ai_usage(company_id, created_at DESC);
GRANT SELECT ON public.ai_usage TO authenticated;
GRANT ALL ON public.ai_usage TO service_role;
ALTER TABLE public.ai_usage ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_usage_select_admin" ON public.ai_usage FOR SELECT TO authenticated USING (company_id IS NOT NULL AND public.is_company_admin(company_id));