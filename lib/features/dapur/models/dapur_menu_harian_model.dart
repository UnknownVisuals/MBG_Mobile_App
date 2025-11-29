class DapurMenuHarianModel {
  DapurMenuHarianModel({
    required this.id,
    this.tanggal,
    this.namaMenu,
    this.biayaPerTray,
    this.jamMulaiMasak,
    this.jamSelesaiMasak,
    this.kalori,
    this.protein,
    this.karbohidrat,
    this.lemak,
    this.targetTray,
    this.createdAt,
    this.updatedAt,
    this.menuPlanningId,
    this.checkpoint,
  });

  final String id;
  final DateTime? tanggal;
  final String? namaMenu;
  final int? biayaPerTray;
  final String? jamMulaiMasak;
  final String? jamSelesaiMasak;
  final double? kalori;
  final double? protein;
  final double? karbohidrat;
  final double? lemak;
  final int? targetTray;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? menuPlanningId;
  final List<DapurMenuHarianCheckpointSummary>? checkpoint;

  factory DapurMenuHarianModel.fromJson(Map<String, dynamic> json) {
    return DapurMenuHarianModel(
      id: json['id'] as String,
      tanggal: json['tanggal'] != null
          ? DateTime.tryParse(json['tanggal'] as String)
          : null,
      namaMenu: json['namaMenu'] as String?,
      biayaPerTray: json['biayaPerTray'] as int?,
      jamMulaiMasak: json['jamMulaiMasak'] as String?,
      jamSelesaiMasak: json['jamSelesaiMasak'] as String?,
      kalori: (json['kalori'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      karbohidrat: (json['karbohidrat'] as num?)?.toDouble(),
      lemak: (json['lemak'] as num?)?.toDouble(),
      targetTray: json['targetTray'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      menuPlanningId: json['menuPlanningId'] as String?,
      checkpoint: (json['checkpoint'] as List<dynamic>?)
          ?.map(
            (e) => DapurMenuHarianCheckpointSummary.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (tanggal != null) 'tanggal': tanggal!.toIso8601String(),
      if (namaMenu != null) 'namaMenu': namaMenu,
      if (biayaPerTray != null) 'biayaPerTray': biayaPerTray,
      if (jamMulaiMasak != null) 'jamMulaiMasak': jamMulaiMasak,
      if (jamSelesaiMasak != null) 'jamSelesaiMasak': jamSelesaiMasak,
      if (kalori != null) 'kalori': kalori,
      if (protein != null) 'protein': protein,
      if (karbohidrat != null) 'karbohidrat': karbohidrat,
      if (lemak != null) 'lemak': lemak,
      if (targetTray != null) 'targetTray': targetTray,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (menuPlanningId != null) 'menuPlanningId': menuPlanningId,
      if (checkpoint != null)
        'checkpoint': checkpoint!.map((e) => e.toJson()).toList(),
    };
  }
}

class DapurMenuHarianCheckpointSummary {
  DapurMenuHarianCheckpointSummary({
    required this.id,
    this.tipe,
    this.fotoUrl,
    this.timestamp,
    this.durasi,
  });

  final String id;
  final String? tipe;
  final String? fotoUrl;
  final DateTime? timestamp;
  int? durasi;

  factory DapurMenuHarianCheckpointSummary.fromJson(Map<String, dynamic> json) {
    return DapurMenuHarianCheckpointSummary(
      id: json['id'] as String,
      tipe: json['tipe'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
      durasi: json['durasi'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (tipe != null) 'tipe': tipe,
      if (fotoUrl != null) 'fotoUrl': fotoUrl,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      'durasi': durasi,
    };
  }
}
