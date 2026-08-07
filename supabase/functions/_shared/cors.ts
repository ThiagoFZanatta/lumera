/**
 * Shared CORS helpers for all edge functions.
 *
 * BLOCO 8 — CORS restrito.
 *
 * Antes, "Access-Control-Allow-Origin: *" deixava QUALQUER site do mundo
 * chamar estas funções direto do navegador do usuário (usando a sessão dele).
 * Agora só as origens em ALLOWED_ORIGINS recebem esse cabeçalho — para
 * qualquer outra origem, o cabeçalho simplesmente não vem, e é o próprio
 * navegador de quem está chamando que bloqueia a resposta.
 *
 * Isso NÃO afeta webhooks externos (Stripe, WhatsApp, Asaas, Open Finance):
 * CORS é uma regra que só o NAVEGADOR aplica. Chamada de servidor para
 * servidor (o caso de todo webhook) nunca passa por essa checagem.
 *
 * QUANDO PUBLICAR O PROJETO: adicione o domínio de produção na lista abaixo.
 */
const ALLOWED_ORIGINS = [
  // Pré-visualização atual do editor Lovable (projeto ainda não publicado):
  "https://id-preview--12048dc3-5784-4d18-bb43-bb1e35ee8bcb.lovable.app",

  // Ambiente local de desenvolvimento (Vite), caso alguém rode o projeto na própria máquina:
  "http://localhost:5173",
  "http://localhost:8080",

  // TODO: quando publicar, adicione aqui o domínio de produção, ex:
  // "https://app.suaempresa.com.br",
];

const BASE_HEADERS: Record<string, string> = {
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
  "Access-Control-Max-Age": "86400",
  // Diz a caches/CDNs intermediários que a resposta varia por origem — evita
  // que uma resposta liberada para a origem A seja servida por engano à B.
  "Vary": "Origin",
};

function origemPermitida(origin: string | null): boolean {
  if (!origin) return false;
  return ALLOWED_ORIGINS.includes(origin);
}

export function getCorsHeaders(
  req: Request,
  extraHeaders?: string,
): Record<string, string> {
  const headers: Record<string, string> = { ...BASE_HEADERS };
  if (extraHeaders) {
    headers["Access-Control-Allow-Headers"] =
      `${BASE_HEADERS["Access-Control-Allow-Headers"]}, ${extraHeaders}`;
  }

  const origin = req.headers.get("origin");
  if (origemPermitida(origin)) {
    headers["Access-Control-Allow-Origin"] = origin as string;
  }
  // Origem fora da lista: nenhum "Access-Control-Allow-Origin" é enviado.
  // A função ainda responde normalmente (webhooks e chamadas server-to-server
  // não usam esse cabeçalho), mas um navegador bloqueia o uso da resposta.

  return headers;
}

export function corsPreflightResponse(
  req: Request,
  extraHeaders?: string,
): Response | null {
  if (req.method !== "OPTIONS") return null;
  return new Response(null, {
    status: 204,
    headers: getCorsHeaders(req, extraHeaders),
  });
}
