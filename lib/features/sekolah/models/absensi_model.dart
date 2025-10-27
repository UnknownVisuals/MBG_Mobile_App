class AbsensiModel {
  final String id;
  final DateTime tanggal;
  final int jumlahHadir;
  final String kelasId;
  final String? kelasNama;
  final DateTime createdAt;
  final DateTime updatedAt;

  AbsensiModel({
    required this.id,
    required this.tanggal,
    required this.jumlahHadir,
    required this.kelasId,
    this.kelasNama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) {
    return AbsensiModel(
      id: json['id'],
      tanggal: DateTime.parse(json['tanggal']),
      jumlahHadir: json['jumlahHadir'],
      kelasId: json['kelasId'],
      kelasNama: json['kelas']?['nama'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String().split('T')[0],
      'jumlahHadir': jumlahHadir,
      'kelasId': kelasId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
