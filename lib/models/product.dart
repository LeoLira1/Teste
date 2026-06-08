import 'dart:convert';

/// Produto cadastrado no mapa de prateleiras.
///
/// As coordenadas [x] e [y] são normalizadas entre 0 e 1 para que o mesmo dado
/// funcione em telas pequenas, grandes, vertical e horizontal.
class Product {
  const Product({
    required this.id,
    required this.nome,
    required this.setor,
    required this.prateleira,
    required this.boxId,
    required this.x,
    required this.y,
    required this.confianca,
  });

  final String id;
  final String nome;
  final String setor;
  final int prateleira;
  final String boxId;
  final double x;
  final double y;
  final double confianca;

  Product copyWith({
    String? id,
    String? nome,
    String? setor,
    int? prateleira,
    String? boxId,
    double? x,
    double? y,
    double? confianca,
  }) {
    return Product(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      setor: setor ?? this.setor,
      prateleira: prateleira ?? this.prateleira,
      boxId: boxId ?? this.boxId,
      x: x ?? this.x,
      y: y ?? this.y,
      confianca: confianca ?? this.confianca,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'setor': setor,
        'prateleira': prateleira,
        'boxId': boxId,
        'x': double.parse(x.toStringAsFixed(3)),
        'y': double.parse(y.toStringAsFixed(3)),
        'confianca': double.parse(confianca.toStringAsFixed(2)),
      };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}
