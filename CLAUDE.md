# Cadastro Imobiliário

App Flutter feito no estágio na **Prefeitura de Rio Paranaíba**: cadastra contribuintes e imóveis, consulta por quarteirão, registra fotos e exporta CSV.

## Arquitetura
```
Flutter ──firebase_auth──> login / registro
        ──cloud_firestore / firebase_database (realtime)──> contribuintes, imóveis, quarteirões
        ──firebase_storage──> fotos dos imóveis
        ──csv + path_provider──> exportação local
```
- `lib/main.dart`: inicializa o Firebase (`firebase_options.dart`, gerado pelo FlutterFire) e a navegação.
- `lib/features/auth/presentation/`: `loginpage`, `registerpage`.
- `lib/features/dashboard/presentation/`: `homepage`, `painel`.
- `lib/features/photos/presentation/`: `galeria`, `previewpage` (camera_camera / image_picker).
- `lib/features/properties/`:
  - `data/functions.dart` (cerca de 380 linhas): todo o acesso ao Firebase.
  - `domain/dados.dart`: modelos.
  - `presentation/`: `forms/contribuinte`, `forms/imovel` (cerca de 410), `quarteiroes`, `realtime`, `cadastro_demo`, `exportar` (**cerca de 700 linhas**, o maior arquivo).
- Estado com GetX em partes da interface.

## Comandos (PowerShell)
```powershell
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
flutter run            # câmera e exportação: teste em Android real
```

## CI e deploy
- `ci.yml` roda pub get, analyze e test.
- Não há deploy automático. O build é manual (`flutter build apk`).

## Regras
- As `apiKey` em `firebase_options.dart` e `GoogleService-Info.plist` são **públicas por design**. Quem protege os dados são as **Firestore/Storage Security Rules**. Nunca dependa só da chave.
- Dados de contribuintes são **pessoais e sensíveis** (LGPD). Nunca use dados reais em testes, prints ou commits.
- Novo acesso ao Firebase vai em `data/`, não na tela. Ao mexer em `exportar.dart`, extraia a lógica de CSV para uma função testável.
- Câmera e exportação precisam ser validadas na plataforma de destino. Diga isso ao relatar.
