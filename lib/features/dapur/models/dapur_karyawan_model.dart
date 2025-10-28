class KaryawanModel {
  KaryawanModel({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.status,
    required this.fotoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.dapurId,
    required this.dapurSummary,
  });

  final String id;
  final String nama;
  final String posisi;
  final String status;
  final String fotoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dapurId;
  final DapurSummary dapurSummary;

  factory KaryawanModel.fromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      posisi: json['posisi'] as String,
      fotoUrl: json['fotoUrl'] as String,
      dapurId: json['dapurId'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dapurSummary: DapurSummary.fromJson(
        json['dapur'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'posisi': posisi,
      'status': status,
      'fotoUrl': fotoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dapurId': dapurId,
      'dapur': dapurSummary.toJson(),
    };
  }
}

class DapurSummary {
  DapurSummary({required this.id, required this.nama});

  final String id;
  final String nama;

  factory DapurSummary.fromJson(Map<String, dynamic> json) {
    return DapurSummary(id: json['id'] as String, nama: json['nama'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}
