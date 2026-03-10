# Perfume Store

App Flutter de gestão interna de lojas — controle de clientes, produtos, estoque e vendas.

> Público-alvo: ~20-30 usuários internos (vendedores/gerentes).

---

## Requisitos

| Ferramenta  | Versão mínima |
| ----------- | ------------- |
| Flutter     | 3.x (stable)  |
| Dart SDK    | ^3.6.1        |
| Android SDK | API 21+       |

**Dependências principais:**

| Pacote                          | Finalidade                                |
| ------------------------------- | ----------------------------------------- |
| `provider ^6.1.2`               | Gerenciamento de estado (ChangeNotifier)  |
| `get_it ^7.6.0`                 | Injeção de dependências (Service Locator) |
| `http ^1.5.0`                   | Requisições HTTP                          |
| `flutter_secure_storage ^9.2.2` | Persistência segura do token JWT          |
| `google_fonts ^6.2.1`           | Tipografia                                |
| `intl ^0.19.0`                  | Formatação de datas e moeda               |

---

## Como rodar

### 1. Instalar dependências

```bash
flutter pub get
```

### 2. Configurar a URL da API

A URL base da API é configurada via `--dart-define`. Se não informada, o app usa o valor de `_defaultBaseUrl` em `lib/core/di/injection.dart`.

**API publicada na web:**

```bash
flutter run --dart-define=BASE_URL=https://minha-api.com/
```

**Emulador Android (localhost da máquina):**

```bash
flutter run --dart-define=BASE_URL=http://10.0.2.2:5000/
```

**Dispositivo físico (mesma rede Wi-Fi):**

```bash
flutter run --dart-define=BASE_URL=http://192.168.x.x:5000/
```

**Ambiente de desenvolvimento sem `--dart-define`:**  
Edite a constante `_defaultBaseUrl` diretamente em `lib/core/di/injection.dart`.

### 3. Executar o app

```bash
flutter run
```

### 4. Gerar APK

```bash
flutter build apk --dart-define=BASE_URL=https://minha-api.com/
```

### Configuração recomendada via VS Code

Crie `.vscode/launch.json` para não repetir o `--dart-define` a cada execução:

```json
{
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=BASE_URL=https://seu-tunel.ngrok-free.app/"]
    },
    {
      "name": "Prod",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=BASE_URL=https://api.sualoja.com/"]
    }
  ]
}
```

---

## Estrutura de Pastas

```
lib/
├── main.dart                          ← Entry point + MultiProvider
├── core/                              ← Infraestrutura compartilhada
│   ├── config/
│   │   ├── app_routes.dart            ← Rotas nomeadas + onGenerateRoute
│   │   └── app_theme.dart             ← Tema Material 3
│   ├── di/
│   │   └── injection.dart             ← Configuração GetIt + BASE_URL
│   ├── network/
│   │   └── http_client.dart           ← Client HTTP com auto-attach de Bearer
│   ├── token_store.dart               ← Token JWT em memória + dados do usuário
│   ├── utils/                         ← Funções utilitárias
│   └── widgets/                       ← Widgets reutilizáveis (AuthGuard, LoadingView, etc.)
│
└── features/
    └── <feature>/
        ├── data/
        │   ├── models/                ← Entities, DTOs, Request models
        │   ├── services/              ← API Services (chamam HttpClient)
        │   └── repositories/          ← Interface abstrata + Implementação
        └── presentation/
            ├── viewmodel/             ← ChangeNotifier ViewModels
            ├── views/                 ← Pages
            └── widgets/               ← Widgets específicos da feature
```

**Features disponíveis:** `login`, `clientes`, `produtos`, `estoques`, `vendas`, `home`

### Regras de organização

- Cada feature é **autocontida** — não importa de outra feature exceto via `core/`
- ViewModels de **lista** são globais (`main.dart`); ViewModels de **detalhe/criação** são locais (criados no ponto de navegação)
- Toda rota protegida usa o widget `AuthGuard`

---

## Autenticação

O app usa JWT fornecido por uma API .NET. O token é:

1. Armazenado em memória pelo `TokenStore` (e persistido via `FlutterSecureStorage`)
2. Decodificado automaticamente — expondo `nomeUsuario`, `roleUsuario` e `userId`
3. Enviado automaticamente como `Bearer` em todas as requisições pelo `HttpClient`
4. Em caso de resposta `401`, o app força logout e redireciona para a tela de login

---

## Documentação adicional

| Arquivo                | Conteúdo                                        |
| ---------------------- | ----------------------------------------------- |
| `PROJECT_STANDARDS.md` | Padrões de código, nomenclatura e arquitetura   |
| `ACTION_PLAN.md`       | Problemas conhecidos, plano de ação e histórico |
| `API_DOCS.md`          | Documentação completa dos endpoints da API      |
