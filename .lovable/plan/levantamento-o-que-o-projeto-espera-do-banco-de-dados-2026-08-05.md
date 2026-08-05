# Levantamento: o que o projeto espera do banco de dados

O código do aplicativo está inteiro e preservado (41 funções de servidor, telas, regras de negócio). O que está vazio é o banco de dados. Abaixo está o inventário completo de tudo que o código procura no banco e hoje não encontra.

## Resumo em números

- 74 tabelas de dados
- 10 relatórios calculados (views)
- 26 rotinas automáticas de banco (funções/RPCs)
- 1 área de arquivos (bucket "documents")
- 41 funções de servidor (essas existem e continuam intactas)
- 0 registros de estrutura salvos (não há histórico de migrações)

## 1. Tabelas que o código utiliza

**Núcleo financeiro (mais usados)**
transactions, receivables, bills_payable, chart_of_accounts, cost_centers, bank_accounts, bank_transactions_raw, invoices, contracts, contacts, products, budgets, monthly_close, kpi_metas, reconciliation_log, company_journal_entries, owner_transactions

**Empresas e acesso**
companies, company_members, company_invites, api_keys, notifications, documents, webhooks, webhook_logs

**Fiscal e notas**
plugnotas_config, plugnotas_documents, nfse_config, focus_config, fiscal_files, tax_guides, tax_rates, municipalities, cclasstrib_codigos, indices_economicos

**Vendas, compras e estoque**
sales_orders, sales_order_items, purchase_orders, purchase_order_items, stock_movements, warehouses

**Integrações bancárias e pagamentos**
inter_config, openfinance_config, bank_connections, stripe_config, stripe_charges, stripe_payouts, stripe_events, company_asaas_config, company_asaas_payments, company_asaas_bills, company_asaas_invoices, company_asaas_subscriptions, company_asaas_transfers, company_asaas_anticipations, company_asaas_webhook_events, contaazul_config

**WhatsApp e IA**
whatsapp_configs, whatsapp_messages, agent_actions, agent_rules, agent_instances, classification_rules, ai_usage

## 2. Relatórios calculados (views)

v_company_margin, v_company_margin_full, v_dre_linhas, v_centro_custo_mes, v_cliente_360, v_recompra_clientes, v_group_account_totals, v_group_ap_ar, v_mrr_movimentos, v_stripe_repasses

## 3. Rotinas automáticas do banco (o "cérebro" das automações)

- **Empresa/plano/bloqueio**: create_company_for_user, plano_da_empresa, plataforma_bloqueada
- **Contratos e propostas**: gerar_link_proposta, ver_proposta, aceitar_proposta, reajustar_contrato, encerrar_recorrencia, gerar_conta_recorrente
- **Fechamento contábil**: fechar_mes, reabrir_mes, ratear_lancamento, fechar_comissao
- **Vendas/estoque/crédito**: faturar_pedido, registrar_movimento_estoque, checar_credito, reserve_next_dps_number
- **Credenciais protegidas (guardadas com criptografia)**: set/get_focus_token, set/get_stripe_credentials, set/get_pluggy_credentials, set/get_contaazul_credentials, rotate_contaazul_refresh_token, resolver_canal_stripe_unico

## 4. O que é risco real de perda

- **Preservado**: todas as telas, todas as 41 funções de servidor, e a lista acima de nomes, campos e chamadas — dá para reconstruir a estrutura a partir do código.
- **Não recuperável**: os dados que existiam dentro das tabelas (lançamentos, clientes, notas). Se havia dados, eles já não estão lá.
- **Parcialmente recuperável**: o conteúdo interno exato das 26 rotinas automáticas e de eventuais gatilhos que existiam só dentro do banco. O código mostra o nome, os parâmetros e o resultado esperado de cada uma, mas não o texto original. Elas precisam ser reescritas seguindo o comportamento que o aplicativo espera.

## 5. Próximo passo sugerido

Reconstruir o banco em blocos, do mais essencial ao mais periférico, cada bloco já nascendo com as regras de segurança (quem pode ver e alterar cada dado) aplicadas:

1. Empresas, membros e permissões (base de tudo)
2. Plano de contas, centros de custo, contatos, contas bancárias
3. Lançamentos, contas a receber e a pagar
4. Contratos, vendas, compras e estoque
5. Fiscal e notas
6. Integrações (bancos, Stripe, Asaas, WhatsApp) com credenciais criptografadas
7. Relatórios calculados e rotinas automáticas
8. Correções de segurança do plano anterior (CORS, webhooks assinados, limite de requisições)

Cada bloco é revisado por você antes de ser aplicado, e nenhum código do aplicativo é apagado no processo.