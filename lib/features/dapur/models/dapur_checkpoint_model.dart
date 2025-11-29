class DapurCheckpointModel {
  DapurCheckpointModel({
    required this.id,
    this.tipe,
    this.fotoUrl,
    this.deskripsi,
    this.timestamp,
    this.durasi,
    this.createdAt,
    this.menuHarianId,
    this.menuHarian,
  });

  final String id;
  final String? tipe;
  final String? fotoUrl;
  final String? deskripsi;
  final DateTime? timestamp;
  int? durasi;
  final DateTime? createdAt;
  final String? menuHarianId;
  final Map<String, dynamic>? menuHarian;

  factory DapurCheckpointModel.fromJson(Map<String, dynamic> json) {
    return DapurCheckpointModel(
      id: json['id'] as String,
      tipe: json['tipe'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      deskripsi: json['deskripsi'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : null,
      durasi: json['durasi'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      menuHarianId: json['menuHarianId'] as String?,
      menuHarian: json['menuHarian'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (tipe != null) 'tipe': tipe,
      if (fotoUrl != null) 'fotoUrl': fotoUrl,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      'durasi': durasi,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (menuHarianId != null) 'menuHarianId': menuHarianId,
      if (menuHarian != null) 'menuHarian': menuHarian,
    };
  }
}
