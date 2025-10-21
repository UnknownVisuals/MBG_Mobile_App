class KaryawanModel {
  final String id;
  final String nama;
  final String posisi;
  final String? fotoUrl;
  final String dapurId;
  final DateTime createdAt;
  final DateTime updatedAt;

  KaryawanModel({
    required this.id,
    required this.nama,
    required this.posisi,
    this.fotoUrl,
    required this.dapurId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KaryawanModel.fromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      id: json['id'],
      nama: json['nama'],
      posisi: json['posisi'],
      fotoUrl: json['fotoUrl'],
      dapurId: json['dapurId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'posisi': posisi,
      'fotoUrl': fotoUrl,
      'dapurId': dapurId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
