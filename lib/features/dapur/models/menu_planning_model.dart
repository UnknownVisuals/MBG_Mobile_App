class MenuPlanningModel {
  final String id;
  final int mingguanKe;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String sekolahId;
  final String dapurId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuPlanningModel({
    required this.id,
    required this.mingguanKe,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.sekolahId,
    required this.dapurId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuPlanningModel.fromJson(Map<String, dynamic> json) {
    return MenuPlanningModel(
      id: json['id'],
      mingguanKe: json['mingguanKe'],
      tanggalMulai: DateTime.parse(json['tanggalMulai']),
      tanggalSelesai: DateTime.parse(json['tanggalSelesai']),
      sekolahId: json['sekolahId'],
      dapurId: json['dapurId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mingguanKe': mingguanKe,
      'tanggalMulai': tanggalMulai.toIso8601String(),
      'tanggalSelesai': tanggalSelesai.toIso8601String(),
      'sekolahId': sekolahId,
      'dapurId': dapurId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
