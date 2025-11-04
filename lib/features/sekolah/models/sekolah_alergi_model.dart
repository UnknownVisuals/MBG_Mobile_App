class SekolahAlergiModel {
  SekolahAlergiModel({
    required this.id,
    required this.namaAlergi,
    required this.siswaId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String namaAlergi;
  final String siswaId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory SekolahAlergiModel.fromJson(Map<String, dynamic> json) {
    return SekolahAlergiModel(
      id: json['id'],
      namaAlergi: json['namaAlergi'],
      siswaId: json['siswaId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaAlergi': namaAlergi,
      'siswaId': siswaId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
