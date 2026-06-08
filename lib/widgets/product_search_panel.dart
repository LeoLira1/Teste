import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductSearchPanel extends StatelessWidget {
  const ProductSearchPanel({
    super.key,
    required this.products,
    required this.query,
    required this.selectedProduct,
    required this.onQueryChanged,
    required this.onProductSelected,
    required this.onReset,
  });

  final List<Product> products;
  final String query;
  final Product? selectedProduct;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<Product> onProductSelected;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((product) {
      final normalized = query.trim().toLowerCase();
      return normalized.isEmpty ||
          product.nome.toLowerCase().contains(normalized) ||
          product.setor.toLowerCase().contains(normalized) ||
          product.id.toLowerCase().contains(normalized);
    }).toList();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                labelText: 'Pesquisar produto',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: selectedProduct == null && query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Resetar seleção',
                        onPressed: onReset,
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Produtos cadastrados (${products.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  final isSelected = product.id == selectedProduct?.id;
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    selected: isSelected,
                    selectedTileColor: const Color(0xFFFFEBEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? const Color(0xFFE53935)
                          : const Color(0xFFF1E0C8),
                      child: Text(
                        product.prateleira.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF6D4C41),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(product.nome),
                    subtitle: Text('${product.setor} • ${product.boxId}'),
                    onTap: () => onProductSelected(product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
