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
    this.nama,
    this.posisi,
    this.status,
    this.fotoUrl,
    this.jenisKelamin,
    this.umur,
    this.createdAt,
    this.updatedAt,
    this.dapurId,
    this.dapurSummary,
  });

  final String id;
  final String? nama;
  final String? posisi;
  final KaryawanStatus? status;
  final String? fotoUrl;
  final JenisKelamin? jenisKelamin;
  final int? umur;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? dapurId;
  final KaryawanDapurSummary? dapurSummary;

  factory DapurKaryawanModel.fromJson(Map<String, dynamic> json) {
    return DapurKaryawanModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      posisi: json['posisi'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      jenisKelamin: json['jenisKelamin'] != null
          ? JenisKelamin.values.firstWhere(
              (e) => e.name == json['jenisKelamin'],
            )
          : null,
      umur: json['umur'] is num ? (json['umur'] as num).toInt() : null,
      dapurId: json['dapurId'] as String?,
      status: json['status'] != null
          ? KaryawanStatus.values.firstWhere((e) => e.name == json['status'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      dapurSummary: json['dapur'] != null
          ? KaryawanDapurSummary.fromJson(json['dapur'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (posisi != null) 'posisi': posisi,
      if (status != null) 'status': status!.name,
      if (fotoUrl != null) 'fotoUrl': fotoUrl,
      if (jenisKelamin != null) 'jenisKelamin': jenisKelamin!.name,
      if (umur != null) 'umur': umur,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (dapurId != null) 'dapurId': dapurId,
      if (dapurSummary != null) 'dapur': dapurSummary!.toJson(),
    };
  }
}

class KaryawanDapurSummary {
  KaryawanDapurSummary({required this.id, this.nama});

  final String id;
  final String? nama;

  factory KaryawanDapurSummary.fromJson(Map<String, dynamic> json) {
    return KaryawanDapurSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, if (nama != null) 'nama': nama};
  }
}
