class MenuHarianModel {
  final String id;
  final DateTime tanggal;
  final String namaMenu;
  final double biayaPerTray;
  final String jamMulaiMasak;
  final String jamSelesaiMasak;
  final double kalori;
  final double protein;
  final double karbohidrat;
  final double lemak;
  final String menuPlanningId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuHarianModel({
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
    required this.menuPlanningId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuHarianModel.fromJson(Map<String, dynamic> json) {
    return MenuHarianModel(
      id: json['id'],
      tanggal: DateTime.parse(json['tanggal']),
      namaMenu: json['namaMenu'],
      biayaPerTray: (json['biayaPerTray'] as num).toDouble(),
      jamMulaiMasak: json['jamMulaiMasak'],
      jamSelesaiMasak: json['jamSelesaiMasak'],
      kalori: (json['kalori'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      karbohidrat: (json['karbohidrat'] as num).toDouble(),
      lemak: (json['lemak'] as num).toDouble(),
      menuPlanningId: json['menuPlanningId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'menuPlanningId': menuPlanningId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
