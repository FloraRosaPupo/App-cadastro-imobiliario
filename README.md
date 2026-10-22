# Cadastro imobiliário

Aplicativo de cadastro de contribuintes e imóveis, com autenticação e recursos de exportação.

## Stack e organização
Flutter/Dart, Firebase, GetX, câmera e CSV. As telas estão em `lib/pages/`. Configure seu projeto Firebase e suas regras de acesso antes de executar; as configurações históricas não garantem acesso a um backend ativo.

## Executar
Use a versão de Flutter registrada em `.github/workflows/ci.yml`.
```sh
git clone https://github.com/FloraRosaPupo/App-cadastro-imobiliario.git
cd App-cadastro-imobiliario
flutter pub get
flutter run
```

## Verificações
```sh
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
```
A CI verifica erros de análise e os testes. Avisos e sugestões continuam visíveis no relatório do analisador. Testes locais não substituem a validação no dispositivo e dos serviços externos.

## Contribuir
Abra uma branch por alteração, descreva o comportamento esperado e inclua testes para regras ou regressões. Mantenha credenciais e arquivos gerados fora do Git.

## Licença
Não há licença de distribuição definida neste repositório.
