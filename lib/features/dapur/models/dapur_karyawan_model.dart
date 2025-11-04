enum KaryawanStatus {
  AKTIF,
  TIDAK_AKTIF;

  String get displayName {
    switch (this) {
      case KaryawanStatus.AKTIF:
        return 'Aktif';
      case KaryawanStatus.TIDAK_AKTIF:
        return 'Tidak Aktif';
    }
  }
}

enum JenisKelamin {
  LAKI_LAKI,
  PEREMPUAN;

  String get displayName {
    switch (this) {
      case JenisKelamin.LAKI_LAKI:
        return 'Laki-Laki';
      case JenisKelamin.PEREMPUAN:
        return 'Perempuan';
    }
  }
}

class DapurKaryawanModel {
  DapurKaryawanModel({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.status,
    this.fotoUrl,
    this.jenisKelamin,
    this.umur,
    required this.createdAt,
    required this.updatedAt,
    required this.dapurId,
    required this.dapurSummary,
  });

  final String id;
  final String nama;
  final String posisi;
  final KaryawanStatus status;
  final String? fotoUrl;
  final JenisKelamin? jenisKelamin;
  final int? umur;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dapurId;
  final KaryawanDapurSummary dapurSummary;

  factory DapurKaryawanModel.fromJson(Map<String, dynamic> json) {
    return DapurKaryawanModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      posisi: json['posisi'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      jenisKelamin: json['jenisKelamin'] != null
          ? JenisKelamin.values.firstWhere(
              (e) => e.name == json['jenisKelamin'],
            )
          : null,
      umur: json['umur'] is num ? (json['umur'] as num).toInt() : null,
      dapurId: json['dapurId'] as String,
      status: KaryawanStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dapurSummary: KaryawanDapurSummary.fromJson(
        json['dapur'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'posisi': posisi,
      'status': status.name,
      'fotoUrl': fotoUrl,
      if (jenisKelamin != null) 'jenisKelamin': jenisKelamin!.name,
      if (umur != null) 'umur': umur,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dapurId': dapurId,
      'dapur': dapurSummary.toJson(),
    };
  }
}

class KaryawanDapurSummary {
  KaryawanDapurSummary({required this.id, required this.nama});

  final String id;
  final String nama;

  factory KaryawanDapurSummary.fromJson(Map<String, dynamic> json) {
    return KaryawanDapurSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}
