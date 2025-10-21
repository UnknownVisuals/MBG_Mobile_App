class DapurModel {
  final String id;
  final String nama;
  final String alamat;
  final String status; // AKTIF, NONAKTIF
  final String? picId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DapurModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.status,
    this.picId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DapurModel.fromJson(Map<String, dynamic> json) {
    return DapurModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      status: json['status'],
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
      'status': status,
      'picId': picId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
