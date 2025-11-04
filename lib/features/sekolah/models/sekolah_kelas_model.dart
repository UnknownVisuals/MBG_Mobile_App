class SekolahKelasModel {
  SekolahKelasModel({
    required this.id,
    required this.nama,
    required this.tingkat,
    this.jumlahSiswa,
    required this.sekolahId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String nama;
  final int tingkat;
  final int? jumlahSiswa;
  final String sekolahId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory SekolahKelasModel.fromJson(Map<String, dynamic> json) {
    return SekolahKelasModel(
      id: json['id'],
      nama: json['nama'],
      tingkat: json['tingkat'],
      jumlahSiswa: json['_count']?['siswa'],
      sekolahId: json['sekolahId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'tingkat': tingkat,
      'sekolahId': sekolahId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
