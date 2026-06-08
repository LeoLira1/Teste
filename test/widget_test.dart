import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_prateleiras/data/mock_products.dart';
import 'package:mapa_prateleiras/main.dart';

void main() {
  testWidgets('mostra título, busca e produtos cadastrados', (tester) async {
    await tester.pumpWidget(const ShelfMapApp());

    expect(find.text('Mapa de Prateleiras'), findsOneWidget);
    expect(find.text('Pesquisar produto'), findsOneWidget);
    expect(find.text('Produtos cadastrados (${mockProducts.length})'), findsOneWidget);
    expect(find.text('Glifosato 20L'), findsOneWidget);
  });

  testWidgets('seleciona produto e mostra localização', (tester) async {
    await tester.pumpWidget(const ShelfMapApp());

    await tester.tap(find.text('Glifosato 20L'));
    await tester.pumpAndSettle();

    expect(find.text('Defensivos • s1-b1'), findsOneWidget);
    expect(find.text('Setor'), findsOneWidget);
    expect(find.text('Confiança'), findsOneWidget);
  });
}
