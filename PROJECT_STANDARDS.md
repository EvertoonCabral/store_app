# Perfume Store — Padrões do Projeto

> **Este arquivo é a fonte de verdade dos padrões do projeto.**  
> Toda geração de código via IA deve respeitar as convenções aqui definidas.  
> Última atualização: 09/03/2026

---

## 1. Visão Geral

| Item                 | Valor                                                                       |
| -------------------- | --------------------------------------------------------------------------- |
| **Nome**             | Perfume Store                                                               |
| **Tipo**             | App Flutter de gestão de loja                                               |
| **Público-alvo**     | ~20-30 usuários internos (vendedores/gerentes)                              |
| **Backend**          | REST API em .NET com autenticação JWT                                       |
| **State Management** | `Provider` + `ChangeNotifier`                                               |
| **DI**               | `GetIt` (Service Locator)                                                   |
| **Escopo funcional** | Login, CRUD Clientes, CRUD Produtos, Controle de Estoque, Vendas, Dashboard |

---

## 2. Estrutura de Diretórios

```
lib/
├── main.dart                          ← Entry point + MultiProvider
├── core/                              ← Infraestrutura compartilhada
│   ├── config/
│   │   ├── app_routes.dart            ← Rotas nomeadas + onGenerateRoute
│   │   └── app_theme.dart             ← Tema Material 3
│   ├── di/
│   │   └── injection.dart             ← Configuração GetIt
│   ├── network/
│   │   └── http_client.dart           ← Client HTTP com auto-attach de Bearer
│   ├── token_store.dart               ← Token JWT em memória
│   ├── utils/                         ← Funções utilitárias
│   └── widgets/                       ← Widgets reutilizáveis (AuthGuard, LoadingView, etc.)
│
└── features/
    └── <feature_name>/
        ├── data/
        │   ├── models/                ← Entities, DTOs, Request models
        │   ├── services/             ← API Services (chamam HttpClient)
        │   └── repositories/         ← Interface abstrata + Implementação
        └── presentation/
            ├── viewmodel/             ← ChangeNotifier ViewModels
            ├── views/                 ← Pages (StatefulWidget / StatelessWidget)
            └── widgets/               ← Widgets específicos da feature
```

### Regras de diretório

- Diretórios de coleção usam **plural**: `models/`, `services/`, `repositories/`, `views/`, `widgets/`
- Um arquivo por classe (exceção: enums pequenos podem coexistir)
- Features são **autocontidas** — nunca importam de outra feature exceto via `core/`

> **Exceção aceita:** `VendaCadastroViewmodel` importa entities de `clientes`, `estoques` e `produtos` porque o fluxo de venda depende dessas entidades. Isso é aceitável enquanto o app não escalar além do escopo atual.

---

## 3. Convenções de Nomenclatura

### 3.1 Arquivos (snake_case)

| Tipo                    | Padrão                                               | Exemplo                                       |
| ----------------------- | ---------------------------------------------------- | --------------------------------------------- |
| Entity / DTO de leitura | `<nome>_entity.dart`                                 | `produto_entity.dart`                         |
| Request model (escrita) | `<nome>_request.dart` ou `<nome>_request_model.dart` | `create_venda_request.dart`                   |
| DTO de filtro           | `<nome>_filtro_dto.dart`                             | `cliente_filtro_dto.dart`                     |
| DTO de criação          | `<nome>_create_dto.dart`                             | `estoque_create_dto.dart`                     |
| Enum                    | `<nome>.dart` (descritivo)                           | `status_venda.dart`, `tipo_movimentacao.dart` |
| API Service             | `<nome>_api_service.dart`                            | `venda_api_service.dart`                      |
| Repository (interface)  | `<nome>_repository.dart`                             | `produto_repository.dart`                     |
| Repository (impl)       | `<nome>_repository_impl.dart`                        | `produto_repository_impl.dart`                |
| ViewModel               | `<nome>_viewmodel.dart`                              | `vendas_list_viewmodel.dart`                  |
| Page                    | `<nome>_page.dart`                                   | `clientes_list_page.dart`                     |
| Widget                  | `<nome>_widget.dart`                                 | `produto_card_widget.dart`                    |

### 3.2 Classes (PascalCase)

| Tipo                   | Padrão                                  | Exemplo                       |
| ---------------------- | --------------------------------------- | ----------------------------- |
| Entity / DTO leitura   | `<Nome>Entity` ou `<Nome>Dto`           | `ProdutoEntity`, `ClienteDto` |
| Request model          | `<Nome>Request` ou `<Nome>RequestModel` | `VendaRequestModel`           |
| API Service            | `<Nome>ApiService`                      | `VendaApiService`             |
| Repository (interface) | `<Nome>Repository`                      | `ProdutoRepository`           |
| Repository (impl)      | `<Nome>RepositoryImpl`                  | `ProdutoRepositoryImpl`       |
| ViewModel              | `<Nome>ViewModel`                       | `AuthViewModel`               |
| Page                   | `<Nome>Page`                            | `LoginPage`                   |

> **Nota:** Atualmente existem inconsistências herdadas (`Viewmodel` vs `ViewModel`). Código **novo** deve usar `ViewModel` (com V maiúsculo). Código existente será corrigido gradualmente.

### 3.3 Métodos nos ViewModels

Usar **português** para métodos de negócio, mantendo consistência com o domínio:

```dart
// ✅ Correto
Future<void> retornaClientes(...) async { ... }
Future<bool> cadastrarVenda() async { ... }
Future<bool> cancelarVenda(int id, {required String motivo}) async { ... }

// ❌ Evitar mistura
Future<void> fetchClientes() async { ... }  // inglês
```

### 3.4 Variáveis de estado nos ViewModels

```dart
bool isLoading = false;      // carregamento principal
bool isSubmitting = false;    // submissão de formulário (se necessário)
String? error;                // mensagem de erro (null = sem erro)
List<T> items = [];           // lista de itens
```

---

## 4. Padrão de Camadas (por feature)

### 4.1 Models (data/models/)

- **Entity / DTO de leitura**: classe imutável com `factory fromJson()`/`fromMap()` para deserializar da API
- **Request model**: classe com método `toJson()`/`toMap()` para serializar para a API
- **Enum**: usar `enum` do Dart com valor associado e parser flexível (`fromAny()` quando a API pode retornar string ou int)

```dart
// Exemplo de Entity
class ClienteDto {
  final int id;
  final String nome;
  // ...

  ClienteDto({required this.id, required this.nome, ...});

  factory ClienteDto.fromJson(Map<String, dynamic> json) => ClienteDto(
    id: json['id'] as int,
    nome: json['nome'] as String,
    // ...
  );
}

// Exemplo de Request
class ClienteRequestModel {
  final String nome;
  // ...

  const ClienteRequestModel({required this.nome, ...});

  Map<String, dynamic> toJson() => {
    'nome': nome,
    // ...
  };
}
```

### 4.2 API Service (data/services/)

- Recebe `HttpClient` no construtor
- Cada método = 1 endpoint da API
- Faz a chamada HTTP e **deserializa** a resposta
- **Não** faz tratamento de erro (deixa exceções propagarem)

```dart
class ProdutoApiServices {
  final HttpClient client;
  ProdutoApiServices(this.client);

  Future<List<ProdutoEntity>> getAllProdutos() async {
    final result = await client.get('api/produto');
    final data = client.decode(result);
    final list = data as List<dynamic>;
    return list
        .map((json) => ProdutoEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
```

### 4.3 Repository (data/repositories/)

- **Interface abstrata** (classe `abstract`) define o contrato
- **Implementação** (`Impl`) delega para o API Service
- Repository é o ponto de abstração para testes/mocks

```dart
// Interface
abstract class ProdutoRepository {
  Future<List<ProdutoEntity>> getProdutos();
  Future<ProdutoEntity> getProdutoById(int? id);
  // ...
}

// Implementação
class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoApiServices api;
  ProdutoRepositoryImpl(this.api);

  @override
  Future<List<ProdutoEntity>> getProdutos() => api.getAllProdutos();
  // ...
}
```

### 4.4 ViewModel (presentation/viewmodel/)

- Extends `ChangeNotifier`
- Recebe Repository no construtor
- Gerencia estado: `isLoading`, `error`, dados
- Faz `try/catch` com mensagens de erro amigáveis
- Chama `notifyListeners()` em mudança de estado

```dart
class ProdutoListViewmodel extends ChangeNotifier {
  final ProdutoRepository repository;
  ProdutoListViewmodel(this.repository);

  bool isLoading = false;
  String? error;
  List<ProdutoEntity> items = [];

  Future<void> retornaProdutos() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      items = await repository.getProdutos();
    } catch (e) {
      error = 'Erro ao carregar produtos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
```

### 4.5 Views (presentation/views/)

- Usam `context.read<VM>()` para ações e `context.watch<VM>()` para rebuild
- Padrão de loading/error/content:

```dart
@override
Widget build(BuildContext context) {
  final vm = context.watch<MeuViewModel>();

  if (vm.isLoading) return const LoadingView();
  if (vm.error != null) return ErrorView(message: vm.error!, onRetry: () => vm.carregar());
  if (vm.items.isEmpty) return const EmptyView();

  return ListView.builder(/* ... */);
}
```

---

## 5. Injeção de Dependências

Toda configuração fica em `lib/core/di/injection.dart`.

### Ordem de registro

```
1. Singletons de infraestrutura (TokenStore, HttpClient)
2. LazySingletons por feature na ordem:
   a. ApiService
   b. Repository
```

### Regra

- `TokenStore` e `HttpClient` → `registerSingleton` (vivem toda a vida do app)
- Api Services e Repositories → `registerLazySingleton` (criados sob demanda, uma instância)
- ViewModels → **NÃO** são registrados no GetIt. São criados via `ChangeNotifierProvider` no `main.dart` ou localmente na tela

---

## 6. Providers e ViewModels

### ViewModels globais (registrados no MultiProvider do main.dart)

Registrar **somente** ViewModels que precisam persistir estado entre navegações:

- `AuthViewModel` — sessão do usuário
- `ClienteListViewModel` — lista de clientes (cache entre idas e voltas)
- `ProdutoListViewmodel` — lista de produtos
- `EstoqueViewmodel` — lista de estoques
- `VendasListViewmodel` — lista de vendas

### ViewModels de escopo local

ViewModels de detalhe/criação devem ser instanciados **localmente** na tela:

```dart
// Na própria page:
ChangeNotifierProvider(
  create: (_) => ProdutoDetailViewmodel(getIt<ProdutoRepository>()),
  child: const ProdutoDetailContent(),
)
```

> **Status:** ✅ Todos os ViewModels de detalhe/criação já utilizam escopo local .

---

## 7. Rede e Autenticação

### HttpClient

- Wrapper do `package:http` em `lib/core/network/http_client.dart`
- Auto-attach do Bearer token via `TokenStore`
- Interceptação global de 401 → `onUnauthorized` callback → força logout e redireciona ao login
- Métodos: `get()`, `post()`, `put()`, `patch()`, `delete()`, `decode()`
- Erros HTTP lançam `Exception` com status code e body

### TokenStore

- Holder in-memory do token JWT e dados do usuário logado
- Ao receber o token (`setToken()`), decodifica automaticamente o payload JWT (base64url) e extrai:
  - `nomeUsuario`
  - `roleUsuario`
  - `userId` —
- `AuthViewModel` persiste/restaura o token via `FlutterSecureStorage`
- Usado pelo `HttpClient` para headers e pelos ViewModels para identificar o usuário
- Getter seguro: `nomeUsuario` retorna `'Desconhecido'` se o claim não existir no JWT
- `clear()` limpa token e todos os dados de usuário no logout

### AuthGuard

- Widget wrapper que verifica `AuthViewModel.isAuthenticated`
- Redireciona para login se não autenticado
- Aplicado em todas as rotas protegidas via `AppRoutes`

---

## 8. Rotas

- Definidas em `lib/core/config/app_routes.dart`
- Rotas simples: map `String → WidgetBuilder` em `AppRoutes.routes`
- Rotas com argumentos: `AppRoutes.onGenerateRoute` (ex: editar produto/cliente)
- Todas as rotas protegidas envolvem o widget com `AuthGuard(child: ...)`
- Padrão de nomes: `/kebab-case` (ex: `/cadastrar-produto`, `/editar-cliente`)

---

## 9. Tema e UI

- Material 3 com seed color `Colors.deepPurple`
- Definido em `lib/core/config/app_theme.dart`
- AppBar: fundo deepPurple, texto branco
- Widgets reutilizáveis em `lib/core/widgets/`:
  - `LoadingView` — indicador de carregamento centralizado
  - `ErrorView` — mensagem de erro + botão "Tentar novamente"
  - `EmptyView` — mensagem de lista vazia
  - `StatusChipWidget` — chip de Ativo/Inativo
  - `AuthGuard` — proteção de rota

---

## 10. Fluxos de Negócio

### 10.1 Fluxo de Venda

```
1. Selecionar Cliente (existente)
2. Selecionar Estoque (de onde sairão os produtos)
3. Adicionar Produtos com quantidade e preço
4. Aplicar desconto (opcional)
5. Validar estoque (POST /api/venda/ValidarEstoque)
6. Cadastrar venda (POST /api/venda/CadastrarVenda) → status: Pendente
7. Finalizar com pagamento (PUT /api/venda/FinalizarVenda) → status: Finalizada
   OU Cancelar (PUT /api/venda/CancelarVenda) → status: Cancelada
```

### 10.2 Fluxo de Estoque

```
1. Criar estoque (nome + descrição)
2. Movimentar: Entrada, Saída, Transferência, Ajuste, Perda, Devolução
3. Consultar itens por estoque
4. Verificar estoque baixo
```

### 10.3 CRUD padrão (Clientes, Produtos)

```
Listar → Criar → Editar → Desativar/Excluir
```

---

## 11. Regras para Geração de Código

Ao gerar código para este projeto, **sempre**:

1. **Seguir a estrutura de camadas** (model → service → repository → viewmodel → view)
2. **Usar português** para nomes de métodos de negócio
3. **Usar `ChangeNotifier`** para ViewModels (não Bloc, não Riverpod)
4. **Registrar dependências** no `injection.dart` seguindo a ordem definida
5. **Usar `AuthGuard`** em toda nova rota protegida
6. **Usar os widgets de `core/widgets/`** para loading, error, empty states
7. **Não criar camada `domain/`** — manter `data/` + `presentation/` por feature
8. **Tratar erros nos ViewModels** com `try/catch` e mensagens amigáveis
9. **Manter consistência** com os padrões de nomenclatura acima
10. **Não importar entre features** diretamente (exceto via `core/` ou nos casos aceitos documentados)
11. **Sempre identificar o usuário logado** nas ações que o backend aceita — quando o body de um endpoint contiver campos como `usuarioResponsavel`, `usuarioVendedor` ou similares (conforme documentado em `API_DOCS.md`), usar `_tokenStore.nomeUsuario` em vez de valores hardcoded. O ViewModel que faz a chamada deve receber `TokenStore` no construtor para acessar os dados do usuário.
