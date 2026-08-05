# Plano: Página inicial em branco

## Objetivo
Substituir a página placeholder padrão do Lovable em `/` por uma tela inicial limpa e em branco, mantendo toda a estrutura do template intacta.

## Alterações
1. **src/routes/index.tsx**
   - Remover o `<img>` placeholder (`data-lovable-blank-page-placeholder`).
   - Renderizar um container vazio que ocupe a tela (`min-h-screen`) sem conteúdo centralizado.
   - Manter a rota `/` funcional.

2. **Metadados (opcional, se necessário)**
   - Atualizar o `head()` da rota `/` para título e descrição genéricos de "Projeto em branco", caso o placeholder exija metadados próprios.

## Fora do escopo
- Nenhuma alteração em `src/routes/__root.tsx`, `src/styles.css`, `src/router.tsx` ou outros arquivos do template.
- Nenhuma funcionalidade, rota, componente ou backend será adicionado.

## Validação
- Build do projeto deve passar sem erros.
- Acessar `/` deve exibir uma tela em branco, sem o logo/ilustração placeholder.
