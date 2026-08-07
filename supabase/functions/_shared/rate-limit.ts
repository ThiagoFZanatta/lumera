/**
 * BLOCO 8 — Limite de requisições.
 *
 * Limitador simples em memória, por instância da function. Não é
 * distribuído entre instâncias diferentes, mas barra rajadas e scripts
 * abusivos em qualquer endpoint público (webhook ou API com chave fixa),
 * sem precisar de tabela nova no banco nem de infraestrutura externa.
 */

const baldes = new Map<string, { contagem: number; expiraEm: number }>();

/** Identificador do chamador: IP de origem (ou "desconhecido" se ausente). */
export function chaveDeLimite(req: Request): string {
  return (
    req.headers.get("x-forwarded-for")?.split(",")[0].trim() ||
    req.headers.get("cf-connecting-ip") ||
    "desconhecido"
  );
}

/**
 * Retorna true se a chave estourou o limite na janela atual.
 * limite: nº máximo de chamadas; janelaMs: duração da janela em ms.
 */
export function estourouLimite(chave: string, limite: number, janelaMs: number): boolean {
  const agora = Date.now();
  const b = baldes.get(chave);
  if (!b || agora > b.expiraEm) {
    baldes.set(chave, { contagem: 1, expiraEm: agora + janelaMs });
    return false;
  }
  b.contagem += 1;
  return b.contagem > limite;
}

export function respostaLimiteExcedido(corsHeaders: Record<string, string>): Response {
  return new Response(
    JSON.stringify({ error: "Muitas requisições. Tente novamente em instantes." }),
    { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
}
