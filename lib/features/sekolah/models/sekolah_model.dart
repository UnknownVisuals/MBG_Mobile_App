class SekolahModel {
  final String id;
  final String nama;
  final String alamat;
  final String? picId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SekolahModel({
    required this.id,
    required this.nama,
    required this.alamat,
    this.picId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SekolahModel.fromJson(Map<String, dynamic> json) {
    return SekolahModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      picId: json['picId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'picId': picId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
