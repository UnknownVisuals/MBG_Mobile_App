class KaryawanModel {
  KaryawanModel({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.dapurId,
    required this.createdAt,
    required this.updatedAt,
    this.fotoUrl,
    this.status,
    this.dapur,
  });

  final String id;
  final String nama;
  final String posisi;
  final String dapurId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fotoUrl;
  final String? status;
  final SimpleDapurSummary? dapur;

  factory KaryawanModel.fromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      posisi: json['posisi'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      dapurId: json['dapurId'] as String,
      status: json['status'] as String?,
      dapur: json['dapur'] is Map<String, dynamic>
          ? SimpleDapurSummary.fromJson(json['dapur'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'posisi': posisi,
      'fotoUrl': fotoUrl,
      'dapurId': dapurId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (dapur != null) 'dapur': dapur!.toJson(),
    };
  }
}

class SimpleDapurSummary {
  SimpleDapurSummary({required this.id, required this.nama});

  final String id;
  final String nama;

  factory SimpleDapurSummary.fromJson(Map<String, dynamic> json) {
    return SimpleDapurSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}
