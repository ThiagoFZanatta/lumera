# Auditoria de segurança e plano de blindagem

Fiz uma varredura completa: banco de dados, todas as 41 funções do backend, o código do site, chaves/segredos, webhooks e dependências. Abaixo, o que encontrei em linguagem simples e o que proponho corrigir, em ordem de urgência.

## O que está bem

- Nenhuma senha ou chave secreta está escrita dentro do código.
- A chave "mestra" do banco (service_role) só é usada no servidor, nunca no navegador.
- A maioria das funções do backend confere quem é o usuário e se ele pertence à empresa antes de responder.
- O verificador automático de vulnerabilidades em bibliotecas não apontou problemas hoje.

## Problemas encontrados

### 1. O banco de dados está completamente vazio (crítico)
Não existe nenhuma tabela no banco hoje, e não existe nenhum arquivo de histórico das mudanças do banco no projeto. Na prática: o "cofre" onde ficam empresas, lançamentos, notas e usuários não existe mais, e as regras de quem pode ver o quê (RLS) sumiram junto. As telas do sistema já estão dando erro por causa disso.

Risco de segurança: se o banco for recriado às pressas, é muito fácil recriá-lo sem as regras de acesso, deixando dados de uma empresa visíveis para clientes de outra.

### 2. Qualquer site da internet pode chamar o backend
Todas as funções aceitam chamadas vindas de qualquer endereço na internet (configuração "aberta"). Isso facilita que uma página maliciosa use o navegador de um usuário logado para disparar ações no sistema.

### 3. Webhook do WhatsApp aceita qualquer um
O endereço que recebe mensagens do WhatsApp não confere nenhuma senha ou assinatura: qualquer pessoa que descubra o endereço pode injetar mensagens falsas e gravar dados no sistema. Outros webhooks (Asaas, genérico) usam senha simples; o do Stripe já valida assinatura corretamente.

### 4. Sem limite de tentativas
Nem a API pública (chave `cfk_...`) nem o login têm limite de tentativas. Um atacante pode testar chaves e senhas indefinidamente sem ser barrado.

### 5. Comparação de chaves e tokens de forma insegura
As chaves de API e tokens de webhook são comparados de forma que, em teoria, permite descobrir o valor por tentativa e medição de tempo. Também são guardados com um método de embaralhamento simples demais.

### 6. Sem monitoramento nem plano de incidente
Não há registro de acessos suspeitos, alerta de tentativa de invasão, nem procedimento definido para o caso de vazamento.

## Plano de correção (4 fases)

### Fase 1 — Reconstruir o cofre com tranca (o mais urgente)
- Recriar todas as tabelas do sistema a partir do código existente, já nascendo com as regras de acesso ativadas.
- Cada tabela só permite que o usuário veja dados das empresas às quais ele pertence.
- Papéis (administrador, usuário, somente leitura) em tabela separada, para impedir que alguém se promova a administrador.
- Gerar arquivos de histórico do banco, para que nada mais se perca e tudo fique auditável.
- Rodar o verificador oficial do banco ao final e corrigir o que ele apontar.

### Fase 2 — Fechar as portas do backend
- Restringir as chamadas apenas aos endereços oficiais do sistema (site publicado e prévia), em vez de "qualquer site".
- Exigir uma senha/assinatura no webhook do WhatsApp e reforçar os demais.
- Trocar as comparações de chave e token por comparação segura, e reforçar o embaralhamento das chaves de API.

### Fase 3 — Barreiras contra ataque em massa
- Limite de tentativas por minuto na API pública e nas funções sensíveis, com bloqueio temporário.
- Validação rigorosa do que entra em cada função (tamanho, formato, tipo), evitando dados maliciosos.
- Revisão final função por função para garantir que nenhuma esqueceu de conferir a empresa do usuário.

### Fase 4 — Vigilância contínua
- Registro de tentativas negadas e alerta quando houver muitas em pouco tempo.
- Rotina de rotação de chaves e de atualização de bibliotecas.
- Documento curto de "o que fazer em caso de suspeita de invasão", em linguagem simples.

## Detalhes técnicos

- Banco: `information_schema` retorna 0 tabelas em `public`; `supabase/migrations/` está vazio; linter e scanners não acusam nada porque não há schema. As chamadas RPC `plataforma_bloqueada`, `cadastro_esta_aberto`, `demonstracao_disponivel` e `limpar_demonstracao_se_remixado` retornam PGRST202.
- CORS: `supabase/functions/_shared/cors.ts` usa `Access-Control-Allow-Origin: *` para todas as funções. Trocar por allowlist de origens.
- Webhooks: `whatsapp-webhook` não valida nada; `company-asaas-webhook` e `webhook-receiver` comparam token com `!==` (usar comparação de tempo constante); `stripe-webhook` já valida HMAC.
- `public-api`: hash `sha256` sem salt em `api_keys.key_hash`, sem rate limit, `limit` máximo 500 — adicionar throttling por chave e comparação constante.
- Reconstrução do schema: derivar de `src/integrations/supabase/types.ts`, das queries das edge functions e dos seeds em `supabase/seed*.sql`; cada `CREATE TABLE` acompanhado de `GRANT` + `ENABLE ROW LEVEL SECURITY` + políticas baseadas em `company_members`.
