import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/product.dart';

/// Mapa visual das prateleiras. Usa somente CustomPainter e dados normalizados,
/// mantendo boa adaptação em orientação retrato e paisagem.
class ShelfMap extends StatelessWidget {
  const ShelfMap({
    super.key,
    required this.products,
    required this.selectedProduct,
    required this.previewX,
    required this.previewY,
    required this.onProductTap,
  });

  final List<Product> products;
  final Product? selectedProduct;
  final double? previewX;
  final double? previewY;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final targetHeight = math.min(
          constraints.maxHeight.isFinite ? constraints.maxHeight : width * 1.1,
          math.max(360, width * 0.9),
        ).toDouble();

        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF2),
              border: Border.all(color: const Color(0xFFE8DDC8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 2.2,
              boundaryMargin: const EdgeInsets.all(48),
              child: GestureDetector(
                onTapUp: (details) => _handleTap(details, Size(width, targetHeight)),
                child: SizedBox(
                  width: width,
                  height: targetHeight,
                  child: CustomPaint(
                    painter: ShelfMapPainter(
                      products: products,
                      selectedProduct: selectedProduct,
                      previewX: previewX,
                      previewY: previewY,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(TapUpDetails details, Size size) {
    final normalized = Offset(
      (details.localPosition.dx / size.width).clamp(0.0, 1.0).toDouble(),
      (details.localPosition.dy / size.height).clamp(0.0, 1.0).toDouble(),
    );

    Product? nearest;
    double nearestDistance = double.infinity;
    for (final product in products) {
      final dx = product.x - normalized.dx;
      final dy = product.y - normalized.dy;
      final distance = math.sqrt(dx * dx + dy * dy);
      if (distance < nearestDistance) {
        nearest = product;
        nearestDistance = distance;
      }
    }

    if (nearest != null && nearestDistance < 0.12) {
      onProductTap(nearest);
    }
  }
}

class ShelfMapPainter extends CustomPainter {
  ShelfMapPainter({
    required this.products,
    required this.selectedProduct,
    required this.previewX,
    required this.previewY,
  });

  final List<Product> products;
  final Product? selectedProduct;
  final double? previewX;
  final double? previewY;

  static const Map<String, Rect> boxLayout = {
    's1-b1': Rect.fromLTWH(0.11, 0.11, 0.14, 0.13),
    's1-b2': Rect.fromLTWH(0.30, 0.10, 0.16, 0.14),
    's1-b3': Rect.fromLTWH(0.51, 0.12, 0.12, 0.12),
    's1-b4': Rect.fromLTWH(0.69, 0.09, 0.18, 0.15),
    's2-b1': Rect.fromLTWH(0.12, 0.31, 0.19, 0.14),
    's2-b2': Rect.fromLTWH(0.36, 0.32, 0.14, 0.13),
    's2-b3': Rect.fromLTWH(0.55, 0.30, 0.10, 0.15),
    's2-b4': Rect.fromLTWH(0.71, 0.31, 0.15, 0.14),
    's3-b1': Rect.fromLTWH(0.10, 0.52, 0.16, 0.13),
    's3-b2': Rect.fromLTWH(0.31, 0.50, 0.14, 0.15),
    's3-b3': Rect.fromLTWH(0.50, 0.53, 0.12, 0.12),
    's3-b4': Rect.fromLTWH(0.67, 0.51, 0.18, 0.14),
    's4-b1': Rect.fromLTWH(0.12, 0.72, 0.18, 0.15),
    's4-b2': Rect.fromLTWH(0.35, 0.74, 0.12, 0.13),
    's4-b3': Rect.fromLTWH(0.51, 0.70, 0.17, 0.17),
    's4-b4': Rect.fromLTWH(0.73, 0.73, 0.14, 0.14),
  };

  @override
  void paint(Canvas canvas, Size size) {
    _paintBrickWall(canvas, size);
    _paintShelves(canvas, size);
    _paintBoxes(canvas, size);
    _paintHeatPoint(canvas, size);
  }

  void _paintBrickWall(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFFFFBF2);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final mortarPaint = Paint()
      ..color = const Color(0xFFEDE2CF)
      ..strokeWidth = 1;
    const rows = 14;
    const cols = 7;
    final brickHeight = size.height / rows;
    final brickWidth = size.width / cols;

    for (var row = 0; row <= rows; row++) {
      final y = row * brickHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), mortarPaint);
    }

    for (var row = 0; row < rows; row++) {
      final offset = row.isEven ? 0.0 : brickWidth / 2;
      for (var col = 0; col <= cols; col++) {
        final x = col * brickWidth - offset;
        canvas.drawLine(
          Offset(x, row * brickHeight),
          Offset(x, (row + 1) * brickHeight),
          mortarPaint,
        );
      }
    }
  }

  void _paintShelves(Canvas canvas, Size size) {
    final shelfPaint = Paint()..color = const Color(0xFFC89255);
    final shelfShadowPaint = Paint()..color = const Color(0x332B1708);
    final metalPaint = Paint()..color = const Color(0xFF9AA0A6);
    final highlightPaint = Paint()..color = const Color(0x33FFFFFF);

    for (final y in const [0.25, 0.46, 0.66, 0.88]) {
      final shelfTop = y * size.height;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.06, shelfTop, size.width * 0.88, 14),
        const Radius.circular(5),
      );
      canvas.drawRRect(
        rect.shift(const Offset(0, 6)),
        shelfShadowPaint,
      );
      canvas.drawRRect(rect, shelfPaint);
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.07, shelfTop + 2, size.width * 0.86, 3),
        highlightPaint,
      );

      for (final x in [size.width * 0.08, size.width * 0.92]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x - 5, shelfTop - 52, 10, 56),
            const Radius.circular(4),
          ),
          metalPaint,
        );
      }
    }
  }

  void _paintBoxes(Canvas canvas, Size size) {
    final boxPaint = Paint()..color = const Color(0xFFC89055);
    final sidePaint = Paint()..color = const Color(0xFFB77B42);
    final tapePaint = Paint()..color = const Color(0xFFD9B37A);
    final selectedBoxPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (final entry in boxLayout.entries) {
      final rect = _scaleRect(entry.value, size).deflate(1);
      final radius = RRect.fromRectAndRadius(rect, const Radius.circular(7));
      canvas.drawRRect(radius, boxPaint);
      canvas.drawRect(
        Rect.fromLTWH(rect.right - rect.width * 0.22, rect.top, rect.width * 0.22, rect.height),
        sidePaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(rect.left + rect.width * 0.44, rect.top + 4, rect.width * 0.12, rect.height - 8),
        tapePaint,
      );
      canvas.drawLine(
        Offset(rect.left + 8, rect.top + rect.height * 0.52),
        Offset(rect.right - 8, rect.top + rect.height * 0.52),
        Paint()
          ..color = const Color(0x33805A32)
          ..strokeWidth = 1,
      );

      if (selectedProduct?.boxId == entry.key) {
        canvas.drawRRect(radius.inflate(4), selectedBoxPaint);
      }
    }
  }

  void _paintHeatPoint(Canvas canvas, Size size) {
    final activeX = previewX ?? selectedProduct?.x;
    final activeY = previewY ?? selectedProduct?.y;
    if (activeX == null || activeY == null) return;

    final center = Offset(activeX * size.width, activeY * size.height);
    final glowPaint = Paint()..color = const Color(0x44E53935);
    final corePaint = Paint()..color = const Color(0xAAE53935);
    canvas.drawCircle(center, 34, glowPaint);
    canvas.drawCircle(center, 13, corePaint);
    canvas.drawCircle(
      center,
      35,
      Paint()
        ..color = const Color(0xFFE53935)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  Rect _scaleRect(Rect rect, Size size) {
    return Rect.fromLTWH(
      rect.left * size.width,
      rect.top * size.height,
      rect.width * size.width,
      rect.height * size.height,
    );
  }

  @override
  bool shouldRepaint(covariant ShelfMapPainter oldDelegate) {
    return oldDelegate.selectedProduct != selectedProduct ||
        oldDelegate.previewX != previewX ||
        oldDelegate.previewY != previewY ||
        oldDelegate.products != products;
  }
}
