class Custo {
  int? id;
  String descricao;
  double valor;
  String categoria;

  Custo({
    this.id,
    required this.descricao,
    required this.valor,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'categoria': categoria,
    };
  }

  factory Custo.fromMap(Map<String, dynamic> map) {
    return Custo(
      id: map['id'],
      descricao: map['descricao'],
      valor: map['valor'],
      categoria: map['categoria'],
    );
  }
}