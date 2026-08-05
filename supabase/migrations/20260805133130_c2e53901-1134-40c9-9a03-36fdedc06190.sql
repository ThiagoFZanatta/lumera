-- Limpeza de demo: só em instalação virgem (sem dono), nunca em base em uso.
CREATE OR REPLACE FUNCTION public.limpar_demonstracao_se_remixado()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE v_owner uuid; v_bloqueada boolean;
BEGIN
  SELECT owner_user_id, plataforma_bloqueada INTO v_owner, v_bloqueada
  FROM public.platform_settings LIMIT 1;
  IF v_owner IS NULL AND NOT coalesce(v_bloqueada, false) THEN
    DELETE FROM public.companies WHERE org_id LIKE 'DEMO-%';
  END IF;
END; $$;

-- Ambiente: gravável só enquanto não houver dono, ou pelo próprio dono.
CREATE OR REPLACE FUNCTION public.registrar_ambiente(p_functions_url text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE v_owner uuid;
BEGIN
  IF p_functions_url !~ '^https://[a-zA-Z0-9._-]+/functions/v1$' THEN RETURN; END IF;
  SELECT owner_user_id INTO v_owner FROM public.platform_settings LIMIT 1;
  IF v_owner IS NULL OR v_owner = auth.uid() THEN
    UPDATE public.platform_settings SET functions_url = p_functions_url
    WHERE functions_url IS DISTINCT FROM p_functions_url;
  END IF;
END; $$;

-- Helpers de RLS: uso interno das políticas, não pela API.
REVOKE ALL ON FUNCTION public.is_company_member(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.is_company_admin(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.is_company_member(uuid) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.is_company_admin(uuid) TO authenticated, service_role;
