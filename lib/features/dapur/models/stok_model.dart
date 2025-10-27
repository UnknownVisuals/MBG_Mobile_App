class StokModel {
  final String id;
  final String nama;
  final String kategori; // SAYUR, BUAH, PROTEIN, KARBOHIDRAT, LAINNYA
  final double stokKg;
  final String dapurId;
  final DateTime createdAt;
  final DateTime updatedAt;

  StokModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.stokKg,
    required this.dapurId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StokModel.fromJson(Map<String, dynamic> json) {
    return StokModel(
      id: json['id'],
      nama: json['nama'],
      kategori: json['kategori'],
      stokKg: (json['stokKg'] as num).toDouble(),
      dapurId: json['dapurId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'stokKg': stokKg,
      'dapurId': dapurId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
