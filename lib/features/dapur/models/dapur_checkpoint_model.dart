class DapurCheckpointModel {
  DapurCheckpointModel({
    required this.id,
    required this.tipe,
    required this.fotoUrl,
    this.deskripsi,
    required this.timestamp,
    this.durasi,
    required this.createdAt,
    required this.menuHarianId,
    this.menuHarian,
  });

  final String id;
  final String tipe;
  final String fotoUrl;
  final String? deskripsi;
  final DateTime timestamp;
  int? durasi;
  final DateTime createdAt;
  final String menuHarianId;
  final Map<String, dynamic>? menuHarian;

  factory DapurCheckpointModel.fromJson(Map<String, dynamic> json) {
    return DapurCheckpointModel(
      id: json['id'] as String,
      tipe: json['tipe'] as String,
      fotoUrl: json['fotoUrl'] as String,
      deskripsi: json['deskripsi'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      durasi: json['durasi'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      menuHarianId: json['menuHarianId'] as String,
      menuHarian: json['menuHarian'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipe': tipe,
      'fotoUrl': fotoUrl,
      'deskripsi': deskripsi,
      'timestamp': timestamp.toIso8601String(),
      'durasi': durasi,
      'createdAt': createdAt.toIso8601String(),
      'menuHarianId': menuHarianId,
      if (menuHarian != null) 'menuHarian': menuHarian,
    };
  }
}
