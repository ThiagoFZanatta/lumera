-- ============ BLOCO 1: EMPRESAS, MEMBROS E PERMISSOES ============

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- ---------- companies ----------
CREATE TABLE public.companies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  cnpj text,
  org_id text,
  regime_tributario text,
  cclasstrib_padrao text,
  plan_key text NOT NULL DEFAULT 'free',
  onboarding_completed boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_companies_org ON public.companies(org_id);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.companies TO authenticated;
GRANT ALL ON public.companies TO service_role;
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

-- ---------- company_members ----------
CREATE TABLE public.company_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'member' CHECK (role IN ('admin','member','viewer')),
  approval_limit numeric,
  onboarding_completed boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, user_id)
);
CREATE INDEX idx_company_members_user ON public.company_members(user_id);
CREATE INDEX idx_company_members_company ON public.company_members(company_id);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.company_members TO authenticated;
GRANT ALL ON public.company_members TO service_role;
ALTER TABLE public.company_members ENABLE ROW LEVEL SECURITY;

-- ---------- company_invites ----------
CREATE TABLE public.company_invites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'member' CHECK (role IN ('admin','member','viewer')),
  token text NOT NULL UNIQUE DEFAULT encode(extensions.gen_random_bytes(24), 'hex'),
  criado_por uuid NOT NULL,
  expires_at timestamptz NOT NULL DEFAULT now() + interval '7 days',
  used_at timestamptz,
  used_by uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_company_invites_company ON public.company_invites(company_id);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.company_invites TO authenticated;
GRANT ALL ON public.company_invites TO service_role;
ALTER TABLE public.company_invites ENABLE ROW LEVEL SECURITY;

-- ---------- platform_settings (uma linha) ----------
CREATE TABLE public.platform_settings (
  id boolean PRIMARY KEY DEFAULT true CHECK (id),
  owner_user_id uuid,
  cadastro_aberto boolean NOT NULL DEFAULT true,
  plataforma_bloqueada boolean NOT NULL DEFAULT false,
  functions_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
INSERT INTO public.platform_settings (id) VALUES (true);

GRANT SELECT ON public.platform_settings TO authenticated;
GRANT ALL ON public.platform_settings TO service_role;
ALTER TABLE public.platform_settings ENABLE ROW LEVEL SECURITY;

-- ---------- funcoes de apoio (security definer, sem recursao de RLS) ----------
CREATE OR REPLACE FUNCTION public.is_company_member(_company_id uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.company_members m
                 WHERE m.company_id = _company_id AND m.user_id = auth.uid());
$$;

CREATE OR REPLACE FUNCTION public.is_company_admin(_company_id uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.company_members m
                 WHERE m.company_id = _company_id AND m.user_id = auth.uid() AND m.role = 'admin');
$$;

-- ---------- politicas ----------
CREATE POLICY "membros veem suas empresas" ON public.companies
  FOR SELECT TO authenticated USING (public.is_company_member(id));
CREATE POLICY "admin edita a empresa" ON public.companies
  FOR UPDATE TO authenticated USING (public.is_company_admin(id)) WITH CHECK (public.is_company_admin(id));
CREATE POLICY "admin remove a empresa" ON public.companies
  FOR DELETE TO authenticated USING (public.is_company_admin(id));

CREATE POLICY "ver membros das minhas empresas" ON public.company_members
  FOR SELECT TO authenticated USING (user_id = auth.uid() OR public.is_company_member(company_id));
CREATE POLICY "admin adiciona membros" ON public.company_members
  FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id));
CREATE POLICY "atualizar membro" ON public.company_members
  FOR UPDATE TO authenticated
  USING (user_id = auth.uid() OR public.is_company_admin(company_id))
  WITH CHECK (user_id = auth.uid() OR public.is_company_admin(company_id));
CREATE POLICY "admin remove membros" ON public.company_members
  FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE POLICY "ver convites da empresa" ON public.company_invites
  FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "admin cria convites" ON public.company_invites
  FOR INSERT TO authenticated WITH CHECK (public.is_company_admin(company_id) AND criado_por = auth.uid());
CREATE POLICY "admin apaga convites" ON public.company_invites
  FOR DELETE TO authenticated USING (public.is_company_admin(company_id));

CREATE POLICY "todos leem configuracao da plataforma" ON public.platform_settings
  FOR SELECT TO authenticated USING (true);

-- ---------- triggers de updated_at ----------
CREATE TRIGGER trg_companies_updated BEFORE UPDATE ON public.companies
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_company_members_updated BEFORE UPDATE ON public.company_members
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER trg_platform_settings_updated BEFORE UPDATE ON public.platform_settings
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ---------- RPCs usados pelo aplicativo ----------
CREATE OR REPLACE FUNCTION public.create_company_for_user(company_name text, company_cnpj text DEFAULT NULL)
RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE v_id uuid; v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RAISE EXCEPTION 'Nao autenticado'; END IF;
  IF coalesce(trim(company_name), '') = '' THEN RAISE EXCEPTION 'Nome da empresa obrigatorio'; END IF;
  INSERT INTO public.companies (name, cnpj) VALUES (trim(company_name), nullif(trim(coalesce(company_cnpj,'')), ''))
  RETURNING id INTO v_id;
  INSERT INTO public.company_members (company_id, user_id, role, onboarding_completed)
  VALUES (v_id, v_uid, 'admin', false);
  RETURN v_id;
END; $$;
REVOKE ALL ON FUNCTION public.create_company_for_user(text, text) FROM public;
GRANT EXECUTE ON FUNCTION public.create_company_for_user(text, text) TO authenticated;

CREATE OR REPLACE FUNCTION public.plano_da_empresa(p_company_id uuid)
RETURNS jsonb LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
DECLARE v_key text;
BEGIN
  SELECT plan_key INTO v_key FROM public.companies WHERE id = p_company_id;
  v_key := coalesce(v_key, 'free');
  RETURN CASE v_key
    WHEN 'enterprise' THEN jsonb_build_object('key','enterprise','nome','Enterprise','whatsapp',true,'contaazul',true,'fiscal',true,'openfinance',true,'ia',true)
    WHEN 'pro' THEN jsonb_build_object('key','pro','nome','Pro','whatsapp',true,'contaazul',true,'fiscal',true,'openfinance',true,'ia',true)
    WHEN 'starter' THEN jsonb_build_object('key','starter','nome','Starter','whatsapp',false,'contaazul',false,'fiscal',true,'openfinance',true,'ia',true)
    ELSE jsonb_build_object('key','free','nome','Gratuito','whatsapp',false,'contaazul',false,'fiscal',false,'openfinance',false,'ia',false)
  END;
END; $$;
GRANT EXECUTE ON FUNCTION public.plano_da_empresa(uuid) TO authenticated, service_role;

CREATE OR REPLACE FUNCTION public.plataforma_bloqueada()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT coalesce((SELECT plataforma_bloqueada FROM public.platform_settings LIMIT 1), false);
$$;
GRANT EXECUTE ON FUNCTION public.plataforma_bloqueada() TO anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.sou_dono_da_plataforma()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT auth.uid() IS NOT NULL
     AND auth.uid() = (SELECT owner_user_id FROM public.platform_settings LIMIT 1);
$$;
GRANT EXECUTE ON FUNCTION public.sou_dono_da_plataforma() TO authenticated, service_role;

CREATE OR REPLACE FUNCTION public.consagrar_dono_se_primeiro()
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE v_uid uuid := auth.uid(); v_owner uuid;
BEGIN
  IF v_uid IS NULL THEN RETURN false; END IF;
  SELECT owner_user_id INTO v_owner FROM public.platform_settings LIMIT 1;
  IF v_owner IS NULL THEN
    UPDATE public.platform_settings SET owner_user_id = v_uid, cadastro_aberto = false;
    RETURN true;
  END IF;
  RETURN v_owner = v_uid;
END; $$;
GRANT EXECUTE ON FUNCTION public.consagrar_dono_se_primeiro() TO authenticated, service_role;

CREATE OR REPLACE FUNCTION public.cadastro_esta_aberto()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT coalesce((SELECT owner_user_id IS NULL OR cadastro_aberto FROM public.platform_settings LIMIT 1), true);
$$;
GRANT EXECUTE ON FUNCTION public.cadastro_esta_aberto() TO anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.demonstracao_disponivel()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.companies WHERE org_id LIKE 'DEMO-%');
$$;
GRANT EXECUTE ON FUNCTION public.demonstracao_disponivel() TO anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.limpar_demonstracao_se_remixado()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NOT coalesce((SELECT plataforma_bloqueada FROM public.platform_settings LIMIT 1), false) THEN
    DELETE FROM public.companies WHERE org_id LIKE 'DEMO-%';
  END IF;
END; $$;
GRANT EXECUTE ON FUNCTION public.limpar_demonstracao_se_remixado() TO anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.registrar_ambiente(p_functions_url text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF p_functions_url ~ '^https://[a-zA-Z0-9._-]+/functions/v1$' THEN
    UPDATE public.platform_settings SET functions_url = p_functions_url
    WHERE functions_url IS DISTINCT FROM p_functions_url;
  END IF;
END; $$;
GRANT EXECUTE ON FUNCTION public.registrar_ambiente(text) TO anon, authenticated, service_role;
