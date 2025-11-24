class SekolahAbsensiModel {
  SekolahAbsensiModel({
    required this.id,
    required this.kelasId,
    required this.tanggal,
    required this.jumlahHadir,
    this.jumlahIzin,
    this.jumlahSakit,
    this.jumlahAlpha,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String kelasId;
  final DateTime tanggal;
  final int jumlahHadir;
  final int? jumlahIzin;
  final int? jumlahSakit;
  final int? jumlahAlpha;
  final String? keterangan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SekolahAbsensiModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return SekolahAbsensiModel(
      id: json['id'] as String,
      kelasId: json['kelasId'] as String,
      tanggal: parseDate(json['tanggal']),
      jumlahHadir: parseInt(json['jumlahHadir']),
      jumlahIzin: json['jumlahIzin'] != null
          ? parseInt(json['jumlahIzin'])
          : null,
      jumlahSakit: json['jumlahSakit'] != null
          ? parseInt(json['jumlahSakit'])
          : null,
      jumlahAlpha: json['jumlahAlpha'] != null
          ? parseInt(json['jumlahAlpha'])
          : null,
      keterangan: json['keterangan'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kelasId': kelasId,
      'tanggal': tanggal.toIso8601String(),
      'jumlahHadir': jumlahHadir,
      if (jumlahIzin != null) 'jumlahIzin': jumlahIzin,
      if (jumlahSakit != null) 'jumlahSakit': jumlahSakit,
      if (jumlahAlpha != null) 'jumlahAlpha': jumlahAlpha,
      if (keterangan != null) 'keterangan': keterangan,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
