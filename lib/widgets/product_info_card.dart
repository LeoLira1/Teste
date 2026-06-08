import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.place_outlined, color: Color(0xFF8D6E63)),
              SizedBox(width: 12),
              Expanded(
                child: Text('Pesquise ou selecione um produto para ver a localização.'),
              ),
            ],
          ),
        ),
      );
    }

    final item = product!;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.location_on, color: Color(0xFFE53935)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.nome,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoChip(label: 'Setor', value: item.setor),
                _InfoChip(label: 'Prateleira', value: item.prateleira.toString()),
                _InfoChip(label: 'Box', value: item.boxId),
                _InfoChip(
                  label: 'Coordenadas',
                  value: 'x ${item.x.toStringAsFixed(2)} / y ${item.y.toStringAsFixed(2)}',
                ),
                _InfoChip(
                  label: 'Confiança',
                  value: '${(item.confianca * 100).round()}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF795548),
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
