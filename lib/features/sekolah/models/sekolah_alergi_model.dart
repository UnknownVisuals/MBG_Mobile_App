class SekolahAlergiModel {
  SekolahAlergiModel({
    required this.id,
    required this.siswaId,
    required this.namaAlergi,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String siswaId;
  final String namaAlergi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SekolahAlergiModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value.toLocal();
      return DateTime.tryParse(value.toString())?.toLocal();
    }

    return SekolahAlergiModel(
      id: json['id'] as String,
      siswaId: json['siswaId'] as String,
      namaAlergi: json['namaAlergi'] as String? ?? '',
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siswaId': siswaId,
      'namaAlergi': namaAlergi,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
