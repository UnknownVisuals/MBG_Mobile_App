class KalenderAkademikModel {
  final String id;
  final String? nama;
  final String? deskripsi;
  final DateTime? tanggal;
  final String? jenis; // LIBUR, KEGIATAN, PENTING
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KalenderAkademikModel({
    required this.id,
    this.nama,
    this.deskripsi,
    this.tanggal,
    this.jenis,
    this.createdAt,
    this.updatedAt,
  });

  factory KalenderAkademikModel.fromJson(Map<String, dynamic> json) {
    return KalenderAkademikModel(
      id: json['id'],
      nama: json['nama'] as String?,
      deskripsi: json['deskripsi'] as String?,
      tanggal: json['tanggal'] != null
          ? DateTime.tryParse(json['tanggal'] as String)
          : null,
      jenis: json['jenis'] as String?,
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
      if (nama != null) 'nama': nama,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (tanggal != null) 'tanggal': tanggal!.toIso8601String(),
      if (jenis != null) 'jenis': jenis,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
