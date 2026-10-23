# Cadastro imobiliário

Aplicativo de cadastro de contribuintes e imóveis, com autenticação e recursos de exportação.

## Stack e organização
Flutter/Dart, Firebase, GetX, câmera, intl e exportação CSV.

Arquivos reunidos em features auth/properties/photos/dashboard. Modelos e funções de dados ficam junto da funcionalidade correspondente. GetX existente foi mantido para preservar navegação e controllers; a recomendação de Cubit não exige trocar tecnologia onde isso não resolve um defeito específico.

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
Consulte [LICENSE.md](LICENSE.md), que contém a declaração de direitos e as restrições de uso do projeto.


## Funcionalidades

- Cadastro de contribuintes e imóveis.
- consulta por quadra.
- fotos e exportação.


## Organização e manutenção

Arquivos reunidos em features auth/properties/photos/dashboard. Modelos e funções de dados ficam junto da funcionalidade correspondente. GetX existente foi mantido para preservar navegação e controllers; a recomendação de Cubit não exige trocar tecnologia onde isso não resolve um defeito específico.

Veja [a revisão de desenvolvimento](docs/REVISAO.md) para decisões, testes e limites, e [o guia de contribuição](CONTRIBUTING.md) para o fluxo de manutenção.
