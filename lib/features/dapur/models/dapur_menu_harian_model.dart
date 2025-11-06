class DapurMenuHarianModel {
  DapurMenuHarianModel({
    required this.id,
    required this.tanggal,
    required this.namaMenu,
    required this.biayaPerTray,
    required this.jamMulaiMasak,
    required this.jamSelesaiMasak,
    required this.kalori,
    required this.protein,
    required this.karbohidrat,
    required this.lemak,
    required this.targetTray,
    required this.createdAt,
    required this.updatedAt,
    required this.menuPlanningId,
    this.checkpoint = const [],
  });

  final String id;
  final DateTime tanggal;
  final String namaMenu;
  final int biayaPerTray;
  final String jamMulaiMasak;
  final String jamSelesaiMasak;
  final double kalori;
  final double protein;
  final double karbohidrat;
  final double lemak;
  final int targetTray;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String menuPlanningId;
  final List<DapurMenuHarianCheckpointSummary> checkpoint;

  factory DapurMenuHarianModel.fromJson(Map<String, dynamic> json) {
    return DapurMenuHarianModel(
      id: json['id'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      namaMenu: json['namaMenu'] as String,
      biayaPerTray: json['biayaPerTray'] as int,
      jamMulaiMasak: json['jamMulaiMasak'] as String,
      jamSelesaiMasak: json['jamSelesaiMasak'] as String,
      kalori: (json['kalori'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      karbohidrat: (json['karbohidrat'] as num).toDouble(),
      lemak: (json['lemak'] as num).toDouble(),
      targetTray: json['targetTray'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      menuPlanningId: json['menuPlanningId'] as String,
      checkpoint:
          (json['checkpoint'] as List<dynamic>?)
              ?.map(
                (e) => DapurMenuHarianCheckpointSummary.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'namaMenu': namaMenu,
      'biayaPerTray': biayaPerTray,
      'jamMulaiMasak': jamMulaiMasak,
      'jamSelesaiMasak': jamSelesaiMasak,
      'kalori': kalori,
      'protein': protein,
      'karbohidrat': karbohidrat,
      'lemak': lemak,
      'targetTray': targetTray,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'menuPlanningId': menuPlanningId,
      'checkpoint': checkpoint.map((e) => e.toJson()).toList(),
    };
  }
}

class DapurMenuHarianCheckpointSummary {
  DapurMenuHarianCheckpointSummary({
    required this.id,
    required this.tipe,
    required this.fotoUrl,
    required this.timestamp,
    this.durasi,
  });

  final String id;
  final String tipe;
  final String fotoUrl;
  final DateTime timestamp;
  int? durasi;

  factory DapurMenuHarianCheckpointSummary.fromJson(Map<String, dynamic> json) {
    return DapurMenuHarianCheckpointSummary(
      id: json['id'] as String,
      tipe: json['tipe'] as String,
      fotoUrl: json['fotoUrl'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      durasi: json['durasi'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipe': tipe,
      'fotoUrl': fotoUrl,
      'timestamp': timestamp.toIso8601String(),
      'durasi': durasi,
    };
  }
}
