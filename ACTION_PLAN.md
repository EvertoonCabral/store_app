# Perfume Store — Plano de Ação e Melhorias

> **Escopo:** App para ~20-30 usuários internos de uma loja de perfumes.  
> Este documento lista os problemas atuais que impactam esse cenário,  
> o plano de correção priorizado e as melhorias futuras de baixa prioridade.  
> Última atualização: 09/03/2026 — Tasks 1.1, 1.2 e 1.3 concluídas (Fase 1 completa)

---

## Índice

1. [Problemas Críticos (bloqueiam uso real)](#1-problemas-críticos)
2. [Problemas Importantes (impactam em semanas)](#2-problemas-importantes)
3. [Plano de Ação](#3-plano-de-ação)
4. [Melhorias Futuras (baixa prioridade)](#4-melhorias-futuras-baixa-prioridade)

---

## 1. Problemas Críticos

Estes problemas **impedem ou comprometem significativamente** o uso por 20-30 usuários.

---

### ~~1.1 Usuário "ADMIN" hardcoded~~ ✅ Resolvido (09/03/2026)

**Onde:** `EstoqueViewmodel`, `EstoqueDetailViewmodel`, `VendaCadastroViewmodel`

**Problema:**  
Todos os campos `usuarioVendedor` e `usuarioResponsavel` enviavam `'ADMIN'` fixo para a API.

**Solução aplicada:**

1. `TokenStore` agora decodifica o payload do JWT automaticamente ao receber o token
2. Extrai `name`, `role` e `nameidentifier` dos claims .NET do JWT
3. Exposição: `tokenStore.nomeUsuario`, `tokenStore.roleUsuario`, `tokenStore.userId`
4. `EstoqueViewmodel`, `EstoqueDetailViewmodel` e `VendaCadastroViewmodel` recebem `TokenStore` via construtor e usam `_tokenStore.nomeUsuario` em vez de `'ADMIN'`
5. `AuthViewModel` expõe `nomeUsuario` e `roleUsuario` para a UI

**Arquivos alterados:**

- `lib/core/token_store.dart`
- `lib/features/login/presentation/viewmodel/auth_viewmodel.dart`
- `lib/features/estoques/presentation/viewmodel/estoque_viewmodel.dart`
- `lib/features/estoques/presentation/viewmodel/estoque_detail_viewmodel.dart`
- `lib/features/vendas/presentation/viewmodel/cadastrar_venda_viewmodel.dart`
- `lib/main.dart`

---

### ~~1.2 URL ngrok hardcoded~~ ✅ Resolvido (09/03/2026)

**Onde:** `lib/core/di/injection.dart`, `lib/main.dart`

**Problema:**  
A base URL da API era uma URL ngrok temporária hardcoded. URLs ngrok mudam a cada reinício do túnel. Para 20-30 usuários, cada mudança exigia gerar e distribuir um novo build.

**Impacto:** Alto — app parava de funcionar toda vez que o túnel reiniciava.

**Solução aplicada:**

1. `main.dart` lê `BASE_URL` via `const String.fromEnvironment('BASE_URL')`
2. Passa para `configureDependencies(baseUrl: ...)` se definida
3. `injection.dart` usa constante `_defaultBaseUrl` como fallback (fácil de alterar em dev)
4. No build: `flutter run --dart-define=BASE_URL=https://minha-api.com/`

**Arquivos alterados:**

- `lib/main.dart`
- `lib/core/di/injection.dart`

---

### 1.3 ViewModels de detalhe/criação globais ✅ Resolvido (09/03/2026)

**Onde:** `main.dart` — MultiProvider raiz

**Problema:**  
`ProdutoDetailViewmodel`, `EstoqueDetailViewmodel`, `VendaCadastroViewmodel` são instâncias únicas globais. Isso causa:

- **Dados residuais:** ao navegar para detalhe do produto A e depois para o B, por um frame o estado do A aparece
- **Erro persistente:** se uma operação falha com `error`, o erro fica visível em outras navegações até alguém limpar

**Impacto:** Médio-Alto — bugs visuais e confusão para o usuário.

**Solução proposta:**  
Mover estes ViewModels para `ChangeNotifierProvider` local na tela que os usa:

```dart
// Antes (main.dart — global):
ChangeNotifierProvider<ProdutoDetailViewmodel>(
  create: (_) => ProdutoDetailViewmodel(getIt<ProdutoRepository>()),
),

// Depois (na page — local):
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => ProdutoDetailViewmodel(getIt<ProdutoRepository>()),
    child: const ProdutoDetailContent(),
  );
}
```

**ViewModels que devem se tornar locais:**

- `ProdutoDetailViewmodel`
- `EstoqueDetailViewmodel`
- `VendaCadastroViewmodel`

**ViewModels que devem continuar globais:**

- `AuthViewModel` (sessão do app)
- `ClienteListViewModel` (lista principal)
- `ProdutoListViewmodel` (lista principal)
- `EstoqueViewmodel` (lista principal)
- `VendasListViewmodel` (lista principal)

**Arquivos afetados:**

- `lib/main.dart` (remover os 3 providers)
- `lib/features/produtos/presentation/views/produto_detail_page.dart`
- `lib/features/estoques/presentation/views/estoque_detail_page.dart`
- `lib/features/vendas/presentation/views/venda_create_page.dart`

---

## 2. Problemas Importantes

Estes problemas **não bloqueiam o lançamento**, mas vão causar dor em poucas semanas de uso real.

---

### 2.1 Pagamento hardcoded como PIX

**Onde:** `lib/features/vendas/presentation/viewmodel/vendas_list_viewmodel.dart`

**Problema:**  
`finalizarVenda()` sempre envia forma de pagamento `'PIX'` com valor integral. A API suporta múltiplas formas (Dinheiro, Cartão Crédito/Débito, PIX, Crediário) e pagamentos parciais (múltiplos pagamentos somando o total).

**Impacto:** Médio — funciona tecnicamente, mas não reflete a operação real da loja.

**Solução proposta:**  
Criar uma tela/bottom sheet de **Finalização de Pagamento** com:

1. Seleção de forma(s) de pagamento
2. Campo de valor por forma
3. Validação: soma dos pagamentos ≥ valor total da venda
4. Para Dinheiro: cálculo de troco

**Arquivos a criar:**

- `lib/features/vendas/presentation/views/finalizar_pagamento_page.dart` (ou widget)
- `lib/features/vendas/data/model/forma_pagamento.dart` (enum)

**Arquivos a alterar:**

- `lib/features/vendas/presentation/viewmodel/vendas_list_viewmodel.dart`
- `lib/features/vendas/presentation/views/venda_detail_page.dart`

---

### 2.2 Ausência de paginação em vendas e produtos

**Onde:** `VendaApiService.getAllVendas()`, `ProdutoApiServices.getAllProdutos()`

**Problema:**  
Esses endpoints retornam **todos** os registros de uma vez. Com 20-30 vendedores fazendo vendas diárias, em 2-3 meses a lista de vendas pode ter milhares de itens. Produtos tendem a crescer mais devagar, mas o problema é o mesmo.

**Impacto:** Médio — degradação gradual de performance, consumo de dados móveis.

**Solução proposta:**

1. Verificar se a API já suporta paginação nesses endpoints (provavelmente sim, baseado no padrão de `/api/cliente`)
2. Criar `VendaFiltroDto` e `ProdutoFiltroDto` análogos a `ClienteFiltroDto`
3. Criar `PagedResult<VendaEntity>` e `PagedResult<ProdutoEntity>`
4. Implementar scroll infinito ou botão "carregar mais" nas listas

**Referência:** A feature de Clientes já implementa isso corretamente com `PagedResult<T>` + `ClienteFiltroDto`.

---

### 2.3 Carga N+1 de nomes de produtos no estoque

**Onde:** `lib/features/estoques/presentation/viewmodel/estoque_detail_viewmodel.dart`

**Problema:**  
`_carregarNomesProdutos()` faz uma chamada HTTP **por produto** no estoque para buscar o nome. Um estoque com 50 produtos = 50 requests sequenciais.

**Impacto:** Médio — lentidão visível em redes móveis.

**Solução proposta (por ordem de preferência):**

1. **Melhor:** Solicitar ao backend que retorne o `nomeProduto` junto com `ItemEstoqueEntity`
2. **Alternativa:** Carregar todos os produtos (`getProdutos()`) uma vez e fazer lookup local
3. **Paliativo:** Fazer as chamadas em paralelo com `Future.wait()`

---

### 2.4 HomePage vazia

**Onde:** `lib/features/home/presentation/home_page.dart`

**Problema:**  
A home exibe apenas uma `ListView` vazia com um `FloatingActionButton` sem ação. Para o fluxo do app, a Home é a primeira tela após login e não oferece nenhuma informação útil.

**Impacto:** Médio — experiência pobre, usuário precisa navegar pelo drawer para tudo.

**Solução proposta:**  
Transformar em um **Dashboard** com:

- Total de vendas do dia/semana (usar `/api/venda/ObterVendas` filtrado)
- Produtos com estoque baixo (API `/api/estoque/estoque-baixo` já existe)
- Últimas vendas realizadas
- Cards de atalho rápido para "Nova Venda", "Novo Cliente"

**Arquivos a criar:**

- `lib/features/home/presentation/viewmodel/home_viewmodel.dart`
- `lib/features/home/presentation/widgets/dashboard_card.dart`
- Possivelmente `lib/features/home/data/` (se precisar de repository dedicado)

**Arquivos a alterar:**

- `lib/features/home/presentation/home_page.dart`
- `lib/main.dart` (registrar HomeViewModel se for global)
- `lib/core/di/injection.dart` (registrar dependências do dashboard)

---

## 3. Plano de Ação

### Fase 1 — Correções para produção (Críticos)

| #       | Tarefa                                                                             | Estimativa   | Prioridade   |
| ------- | ---------------------------------------------------------------------------------- | ------------ | ------------ |
| ~~1.1~~ | ~~Extrair dados do usuário logado (decodificar JWT) e eliminar "ADMIN" hardcoded~~ | ✅ Concluído | ✅ Resolvido |
| ~~1.2~~ | ~~Configurar base URL via `dart-define` ou variável de ambiente~~                  | ✅ Concluído | ✅ Resolvido |
| ~~1.3~~ | ~~Mover ViewModels de detalhe/criação para escopo local~~                          | ✅ Concluído | ✅ Resolvido |

### Fase 2 — Funcionalidades para uso real (Importantes)

| #   | Tarefa                                                            | Estimativa | Prioridade    |
| --- | ----------------------------------------------------------------- | ---------- | ------------- |
| 2.1 | Implementar tela de finalização de pagamento com múltiplas formas | ~4-6h      | 🟡 Importante |
| 2.2 | Adicionar paginação em vendas e produtos                          | ~3-4h      | 🟡 Importante |
| 2.3 | Resolver carga N+1 de nomes de produtos no detalhe de estoque     | ~1-2h      | 🟡 Importante |
| 2.4 | Implementar Dashboard na HomePage                                 | ~4-6h      | 🟡 Importante |

### Fase 3 — Refinamento (Desejável)

| #   | Tarefa                                                       | Estimativa | Prioridade   |
| --- | ------------------------------------------------------------ | ---------- | ------------ |
| 3.1 | Padronizar nomenclatura (ViewModel vs Viewmodel, diretórios) | ~1h        | 🟢 Desejável |
| 3.2 | Testes unitários para ViewModels principais                  | ~4-8h      | 🟢 Desejável |
| 3.3 | Melhorar tratamento de erros (Result<T> ou mensagens da API) | ~2-3h      | 🟢 Desejável |

---

## 4. Melhorias Futuras (Baixa Prioridade)

Estas melhorias **não são necessárias** para o escopo atual (20-30 usuários), mas podem agregar valor no futuro.

---

### 4.1 Testes Unitários

**O que:** Escrever testes para ViewModels, Repositories e HttpClient.

**Por que agora não:** O app funciona e a equipe é pequena. O risco de não ter testes é gerenciável.

**Quando faz sentido:** Quando começar a refatorar lógica complexa (ex: fluxo de vendas) ou adicionar novas features.

**O que priorizar se/quando fizer:**

1. `VendaCadastroViewmodel` — lógica de cálculo de totais, validação
2. `AuthViewModel` — fluxo de login/logout/restore
3. `HttpClient` — interceptação de 401, headers

---

### 4.2 Padronização de Nomenclatura

**O que:** Unificar `Viewmodel` → `ViewModel`, `model/` → `models/`, `service/` → `services/`.

**Por que agora não:** Funciona, é cosmético. Pode causar conflitos se feito de uma vez.

**Quando faz sentido:** Em um momento de "limpeza" planejado, sem features novas em paralelo.

---

### 4.3 Modelo Result<T> para tratamento de erros

**O que:** Substituir `throw Exception` + `try/catch` por um tipo `Result<T>`:

```dart
sealed class Result<T> {
  const Result();
}
class Success<T> extends Result<T> { final T data; const Success(this.data); }
class Failure<T> extends Result<T> { final String message; final int? code; const Failure(this.message, {this.code}); }
```

**Por que agora não:** O padrão atual funciona. Mensagens de erro são genéricas mas aceitáveis.

**Quando faz sentido:** Quando quiser exibir mensagens de erro específicas vindas do servidor (ex: "CPF já cadastrado") de forma elegante na UI.

---

### 4.4 Migração para go_router

**O que:** Substituir `Navigator 1.0` + `AuthGuard` manual por roteamento declarativo.

**Por que agora não:** O roteamento atual funciona para o número de telas existente (~15 rotas). `AuthGuard` cumpre o papel.

**Quando faz sentido:** Se precisar de deep linking, rotas aninhadas, ou o número de telas crescer significativamente.

---

### 4.5 Camada Domain (Clean Architecture)

**O que:** Adicionar `domain/` com entities puras, interfaces e use cases desacoplados da API.

**Por que agora não:** O app é pequeno, a API é estável, e o time é reduzido. A complexidade adicional não compensa.

**Quando faz sentido:** Se a API mudar estruturalmente, ou se o app precisar funcionar offline com cache local.

---

### 4.6 Filtros avançados nas listagens

**O que:** Adicionar filtros por nome, data, status nas telas de listagem de produtos, vendas e estoques (Clientes já tem filtro de paginação).

**Por que agora não:** Com poucos registros no início, a busca manual pelo scroll é viável.

**Quando faz sentido:** Quando as listas crescerem e o usuário reclamar que não encontra o que procura.

---

### 4.7 Feedback visual com SnackBar padronizado

**O que:** Criar um sistema de SnackBar/Toast centralizado para exibir sucesso/erro após operações.

**Por que agora não:** Algumas telas já exibem mensagens, mas não há um padrão. Funcional.

**Quando faz sentido:** Na Fase 2, junto com as demais melhorias de UX.

---

### 4.8 Suporte offline básico

**O que:** Cache de listas (produtos, clientes) em SQLite/Hive para uso quando sem rede.

**Por que agora não:** Uso interno em loja com Wi-Fi. Não é cenário prioritário.

**Quando faz sentido:** Se vendedores forem usar o app em campo/fora da loja.

---

## Resumo Visual

```
  ┌──────────────────────────────────────────────────────┐
  │              FASE 1 — Crítico ✅ COMPLETA             │
  │  ✅ Usuário logado │ ✅ URL fixa │ ✅ ViewModels locais │
  │              todas as tarefas concluídas              │
  ├──────────────────────────────────────────────────────┤
  │                FASE 2 — Importante                   │
  │  Pagamento │ Paginação │ N+1 fix │ Dashboard         │
  │                   ~12-18h total                      │
  ├──────────────────────────────────────────────────────┤
  │                FASE 3 — Desejável                    │
  │    Nomenclatura │ Testes │ Result<T>                 │
  │                   ~7-12h total                       │
  ├──────────────────────────────────────────────────────┤
  │             FUTURO — Baixa Prioridade                │
  │  go_router │ Domain │ Filtros │ Offline │ SnackBar   │
  │                indefinido                            │
  └──────────────────────────────────────────────────────┘
```

---

## Histórico de Implementações

### Tarefa 1.1 — Extrair dados do usuário logado (JWT)

**Problema:** String `'ADMIN'` hardcoded em `EstoqueViewmodel`, `EstoqueDetailViewmodel` e `VendaCadastroViewmodel`.

**Solução:** `TokenStore` passou a decodificar o payload JWT automaticamente, expondo `nomeUsuario`, `roleUsuario` e `userId`. Os três ViewModels recebem `TokenStore` por injeção e leem o nome do usuário de lá.

**Arquivos alterados:** `token_store.dart`, `estoque_viewmodel.dart`, `estoque_detail_viewmodel.dart`, `cadastrar_venda_viewmodel.dart`, `main.dart`.

---

### Tarefa 1.3 — Mover ViewModels de detalhe/criação para escopo local

**Problema:** `ProdutoDetailViewmodel`, `EstoqueDetailViewmodel` e `VendaCadastroViewmodel` eram instanciados uma única vez no `MultiProvider` de `main.dart`, causando vazamento de estado entre navegações (dados de uma tela persistiam ao abrir outra).

**Solução:** Cada ViewModel agora é criado localmente no ponto de navegação via `ChangeNotifierProvider`:

| ViewModel                | Onde é criado                                       |
| ------------------------ | --------------------------------------------------- |
| `ProdutoDetailViewmodel` | `produto_card_widget.dart` (no `MaterialPageRoute`) |
| `EstoqueDetailViewmodel` | `estoque_card_widget.dart` (no `MaterialPageRoute`) |
| `VendaCadastroViewmodel` | `app_routes.dart` (na rota `cadastrarVenda`)        |

**Arquivos alterados:** `main.dart`, `produto_card_widget.dart`, `estoque_card_widget.dart`, `app_routes.dart`.

---

### Tarefa 1.2 — Configurar base URL via dart-define

**Problema:** URL ngrok hardcoded em `injection.dart`. Cada troca de túnel exigia novo build.

**Solução:** `main.dart` lê `BASE_URL` via `String.fromEnvironment('BASE_URL')` e passa para `configureDependencies()`. `injection.dart` usa constante `_defaultBaseUrl` como fallback de desenvolvimento.

**Uso:** `flutter run --dart-define=BASE_URL=https://minha-api.com/`

**Arquivos alterados:** `main.dart`, `injection.dart`.
