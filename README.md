# Mapa de Prateleiras

Aplicativo Android em Flutter para localizar produtos em uma loja usando um mapa visual de prateleiras. A tela principal desenha uma parede de tijolinhos claros, quatro prateleiras de madeira, suportes metálicos e caixas de papelão. Ao pesquisar ou selecionar um produto, o app destaca a caixa relacionada e mostra um círculo vermelho translúcido na posição aproximada do item.

## Funcionalidades

- Busca por produto, setor ou id.
- Lista **Produtos cadastrados** com 12 produtos mockados em Dart.
- Mapa responsivo com `CustomPainter` e zoom básico via `InteractiveViewer`.
- Destaque da caixa relacionada com borda vermelha.
- Círculo vermelho translúcido no ponto `x/y` do produto.
- Card de detalhes com nome, setor, prateleira, box, coordenadas e confiança.
- Modo simples de edição com sliders de X e Y.
- Botão para copiar/exportar o JSON atualizado do produto.
- Botão para resetar seleção.
- Sem Firebase, login, banco de dados real ou API externa dentro do app.

## Estrutura principal

```text
lib/main.dart
lib/models/product.dart
lib/data/mock_products.dart
lib/widgets/shelf_map.dart
lib/widgets/product_search_panel.dart
lib/widgets/product_info_card.dart
lib/widgets/editor_panel.dart
test/widget_test.dart
.github/workflows/build-apk.yml
```

## Como rodar localmente

> Pré-requisito: Flutter estável instalado e configurado no computador.

```bash
./tool/ensure_android_project.sh
flutter pub get
flutter run
```

Para rodar em Android, conecte um aparelho com depuração USB ou inicie um emulador Android antes do `flutter run`.

## Como gerar APK localmente

```bash
./tool/ensure_android_project.sh
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

O script `tool/ensure_android_project.sh` cria o diretório `android/` caso ele ainda não exista no clone local. O APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Como pegar o APK pelo GitHub Actions

1. Envie este projeto para um repositório no GitHub.
2. Abra o repositório no GitHub.
3. Clique na aba **Actions**.
4. Abra o último workflow **Build APK**.
5. No fim da página do workflow, baixe o artifact chamado **mapa-prateleiras-apk**.
6. Extraia o arquivo baixado para acessar `app-release.apk`.

## Como adicionar novos produtos

Edite o arquivo `lib/data/mock_products.dart` e adicione um novo item na lista `mockProducts`:

```dart
Product(
  id: 'prod-013',
  nome: 'Novo Produto',
  setor: 'Setor Exemplo',
  prateleira: 1,
  boxId: 's1-b1',
  x: 0.18,
  y: 0.19,
  confianca: 0.90,
),
```

Campos obrigatórios:

- `id`: identificador único do produto.
- `nome`: nome exibido na busca e nos detalhes.
- `setor`: agrupamento ou área da loja.
- `prateleira`: número da prateleira visual, de 1 a 4.
- `boxId`: id da caixa desenhada no mapa, como `s1-b1`, `s2-b4`, `s4-b3`.
- `x`: posição horizontal normalizada.
- `y`: posição vertical normalizada.
- `confianca`: número entre 0 e 1 que representa a precisão estimada.

## Como funciona x/y no mapa

As coordenadas `x` e `y` são normalizadas entre `0.0` e `1.0`:

- `x = 0.0` fica no lado esquerdo do mapa.
- `x = 1.0` fica no lado direito do mapa.
- `y = 0.0` fica no topo do mapa.
- `y = 1.0` fica na parte inferior do mapa.

Isso permite que o mesmo cadastro funcione em celulares diferentes e também quando o aparelho está na vertical ou na horizontal. O modo edição usa sliders para ajustar esses valores e pré-visualizar o ponto no mapa antes de copiar o JSON atualizado.

## Deploy no GitHub

```bash
git init
git add .
git commit -m "Initial Flutter shelf map app"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git push -u origin main
```

Depois do push, o GitHub Actions executa o workflow e disponibiliza o artifact **mapa-prateleiras-apk**.

## Próximos passos para banco SQLite ou Turso

1. Criar uma camada de repositório, por exemplo `lib/repositories/product_repository.dart`.
2. Manter a UI consumindo uma interface de repositório, em vez de acessar `mockProducts` diretamente.
3. Para SQLite local, adicionar um pacote como `sqflite` ou `drift` e criar tabela `products` com os campos atuais.
4. Para Turso, criar uma API segura intermediária ou usar um cliente compatível, protegendo credenciais fora do app.
5. Implementar migrações, tela de cadastro/edição persistente e sincronização quando necessário.
6. Substituir gradualmente `mockProducts` por leituras reais do repositório.
