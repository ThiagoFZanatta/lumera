ALTER TABLE public.webhooks RENAME COLUMN secret TO secret_token;
ALTER TABLE public.webhook_logs RENAME COLUMN request_payload TO payload;
ALTER TABLE public.webhook_logs ADD COLUMN status text NOT NULL DEFAULT 'pending';

DROP VIEW public.v_recompra_clientes;
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
), calc AS (
  SELECT b.*,
         CASE WHEN b.n_compras > 0 THEN b.total_gasto / b.n_compras END AS ticket_medio,
         CASE WHEN b.n_compras > 1
              THEN (b.ultima_compra - b.primeira_compra)::numeric / (b.n_compras - 1) END AS intervalo_medio_dias,
         (current_date - b.ultima_compra) AS dias_desde_ultima
  FROM base b
)
SELECT company_id, contact_id, name, whatsapp, n_compras, primeira_compra, ultima_compra,
       total_gasto, tem_contrato, ticket_medio, intervalo_medio_dias, dias_desde_ultima,
       CASE WHEN intervalo_medio_dias IS NOT NULL
            THEN ultima_compra + (intervalo_medio_dias::int) END AS proxima_esperada,
       CASE
         WHEN n_compras <= 1 THEN 'novo'
         WHEN dias_desde_ultima > 2 * intervalo_medio_dias THEN 'perdido'
         WHEN dias_desde_ultima > intervalo_medio_dias THEN 'atrasado'
         WHEN dias_desde_ultima >= 0.8 * intervalo_medio_dias THEN 'previsto'
         ELSE 'em_dia'
       END AS status
FROM calc;
GRANT SELECT ON public.v_recompra_clientes TO authenticated;