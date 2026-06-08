import 'package:flutter/material.dart';

import 'data/mock_products.dart';
import 'models/product.dart';
import 'widgets/editor_panel.dart';
import 'widgets/product_info_card.dart';
import 'widgets/product_search_panel.dart';
import 'widgets/shelf_map.dart';

void main() {
  runApp(const ShelfMapApp());
}

class ShelfMapApp extends StatelessWidget {
  const ShelfMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa de Prateleiras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8D6E63),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F1E8),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Product? _selectedProduct;
  String _query = '';
  double? _draftX;
  double? _draftY;

  double get _effectiveX => _draftX ?? _selectedProduct?.x ?? 0.5;
  double get _effectiveY => _draftY ?? _selectedProduct?.y ?? 0.5;

  void _selectProduct(Product product) {
    setState(() {
      _selectedProduct = product;
      _draftX = product.x;
      _draftY = product.y;
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedProduct = null;
      _query = '';
      _draftX = null;
      _draftY = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Mapa de Prateleiras'),
        actions: [
          IconButton(
            tooltip: 'Resetar seleção',
            onPressed: _resetSelection,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 860;
            final map = ShelfMap(
              products: mockProducts,
              selectedProduct: _selectedProduct,
              previewX: _selectedProduct == null ? null : _effectiveX,
              previewY: _selectedProduct == null ? null : _effectiveY,
              onProductTap: _selectProduct,
            );
            final controls = _ControlsColumn(
              query: _query,
              selectedProduct: _selectedProduct,
              draftX: _effectiveX,
              draftY: _effectiveY,
              onQueryChanged: (value) => setState(() => _query = value),
              onProductSelected: _selectProduct,
              onReset: _resetSelection,
              onXChanged: (value) => setState(() => _draftX = value),
              onYChanged: (value) => setState(() => _draftY = value),
            );

            if (isWide) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: map),
                    const SizedBox(width: 16),
                    SizedBox(width: 390, child: controls),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProductSearchPanel(
                  products: mockProducts,
                  query: _query,
                  selectedProduct: _selectedProduct,
                  onQueryChanged: (value) => setState(() => _query = value),
                  onProductSelected: _selectProduct,
                  onReset: _resetSelection,
                ),
                const SizedBox(height: 16),
                SizedBox(height: constraints.maxHeight * 0.56, child: map),
                const SizedBox(height: 16),
                ProductInfoCard(product: _selectedProduct?.copyWith(x: _effectiveX, y: _effectiveY)),
                const SizedBox(height: 16),
                EditorPanel(
                  product: _selectedProduct,
                  draftX: _effectiveX,
                  draftY: _effectiveY,
                  onXChanged: (value) => setState(() => _draftX = value),
                  onYChanged: (value) => setState(() => _draftY = value),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ControlsColumn extends StatelessWidget {
  const _ControlsColumn({
    required this.query,
    required this.selectedProduct,
    required this.draftX,
    required this.draftY,
    required this.onQueryChanged,
    required this.onProductSelected,
    required this.onReset,
    required this.onXChanged,
    required this.onYChanged,
  });

  final String query;
  final Product? selectedProduct;
  final double draftX;
  final double draftY;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<Product> onProductSelected;
  final VoidCallback onReset;
  final ValueChanged<double> onXChanged;
  final ValueChanged<double> onYChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductSearchPanel(
          products: mockProducts,
          query: query,
          selectedProduct: selectedProduct,
          onQueryChanged: onQueryChanged,
          onProductSelected: onProductSelected,
          onReset: onReset,
        ),
        const SizedBox(height: 16),
        ProductInfoCard(product: selectedProduct?.copyWith(x: draftX, y: draftY)),
        const SizedBox(height: 16),
        EditorPanel(
          product: selectedProduct,
          draftX: draftX,
          draftY: draftY,
          onXChanged: onXChanged,
          onYChanged: onYChanged,
        ),
      ],
    );
  }
}
