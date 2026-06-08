import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';

class EditorPanel extends StatelessWidget {
  const EditorPanel({
    super.key,
    required this.product,
    required this.draftX,
    required this.draftY,
    required this.onXChanged,
    required this.onYChanged,
  });

  final Product? product;
  final double draftX;
  final double draftY;
  final ValueChanged<double> onXChanged;
  final ValueChanged<double> onYChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, size: 20),
                const SizedBox(width: 8),
                Text('Modo edição de coordenadas', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            if (product == null)
              const Text('Selecione um produto para ajustar X/Y e exportar o JSON atualizado.')
            else ...[
              Text(
                product!.nome,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _CoordinateSlider(
                label: 'X horizontal',
                value: draftX,
                onChanged: onXChanged,
              ),
              _CoordinateSlider(
                label: 'Y vertical',
                value: draftY,
                onChanged: onYChanged,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    final updated = product!.copyWith(x: draftX, y: draftY);
                    await Clipboard.setData(ClipboardData(text: updated.toPrettyJson()));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('JSON do produto copiado para a área de transferência.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar/exportar JSON atualizado'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CoordinateSlider extends StatelessWidget {
  const _CoordinateSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value.clamp(0.0, 1.0).toDouble(),
          min: 0,
          max: 1,
          divisions: 100,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
