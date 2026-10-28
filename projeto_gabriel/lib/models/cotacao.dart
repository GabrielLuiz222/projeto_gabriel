class Cotacao {
  final String? moneda;
  final String? casa;
  final String? nombre;
  final double? compra;
  final double? venta;
  final DateTime? fechaActualizacion;

  const Cotacao({
    this.moneda,
    this.casa,
    this.nombre,
    this.compra,
    this.venta,
    this.fechaActualizacion,
  });

  String get chave {
    final codigo = moneda ?? '';
    final origem = casa ?? '';
    return '$codigo|$origem';
  }

  String get titulo {
    if (nombre != null && nombre!.trim().isNotEmpty) {
      return nombre!;
    }
    if (moneda != null && moneda!.trim().isNotEmpty) {
      return moneda!;
    }
    return 'Cotação';
  }

  bool get temTaxaCompra => compra != null && compra! > 0;
  bool get temTaxaVenda => venta != null && venta! > 0;
  bool get temAlgumaTaxa => temTaxaCompra || temTaxaVenda;
  bool get ehReal => moneda?.toUpperCase() == 'BRL';

  double? compraEmReais(Cotacao? real) =>
      converterArsParaBrl(compra, real?.compra);

  double? vendaEmReais(Cotacao? real) =>
      converterArsParaBrl(venta, real?.venta);

  factory Cotacao.fromJson(Map<String, dynamic> json) {
    return Cotacao(
      moneda: _texto(json['moneda']),
      casa: _texto(json['casa']),
      nombre: _texto(json['nombre']),
      compra: _numero(json['compra']),
      venta: _numero(json['venta']),
      fechaActualizacion: _data(json['fechaActualizacion']),
    );
  }

  static String? _texto(dynamic valor) {
    if (valor is String) {
      final texto = valor.trim();
      return texto.isEmpty ? null : texto;
    }
    return null;
  }

  static double? _numero(dynamic valor) {
    if (valor == null) return null;
    if (valor is num) return valor.toDouble();
    if (valor is String) {
      return double.tryParse(valor.replaceAll(',', '.'));
    }
    return null;
  }

  static DateTime? _data(dynamic valor) {
    if (valor is! String || valor.trim().isEmpty) return null;
    return DateTime.tryParse(valor);
  }
}

double? converterArsParaBrl(double? valorArs, double? arsPorUmReal) {
  if (valorArs == null || arsPorUmReal == null || arsPorUmReal <= 0) {
    return null;
  }
  return valorArs / arsPorUmReal;
}
