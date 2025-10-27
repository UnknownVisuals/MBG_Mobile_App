class KalenderAkademikModel {
  final String id;
  final String nama;
  final String deskripsi;
  final DateTime tanggal;
  final String jenis; // LIBUR, KEGIATAN, PENTING
  final DateTime createdAt;
  final DateTime updatedAt;

  KalenderAkademikModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
    required this.jenis,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KalenderAkademikModel.fromJson(Map<String, dynamic> json) {
    return KalenderAkademikModel(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
      jenis: json['jenis'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'tanggal': tanggal.toIso8601String(),
      'jenis': jenis,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
