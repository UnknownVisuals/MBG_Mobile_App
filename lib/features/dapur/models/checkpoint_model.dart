class CheckpointModel {
  final String id;
  final String tipe; // MULAI_MEMASAK, SELESAI_MEMASAK
  final String? foto;
  final DateTime waktu;
  final String menuHarianId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CheckpointModel({
    required this.id,
    required this.tipe,
    this.foto,
    required this.waktu,
    required this.menuHarianId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckpointModel.fromJson(Map<String, dynamic> json) {
    return CheckpointModel(
      id: json['id'],
      tipe: json['tipe'],
      foto: json['foto'],
      waktu: DateTime.parse(json['waktu']),
      menuHarianId: json['menuHarianId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipe': tipe,
      'foto': foto,
      'waktu': waktu.toIso8601String(),
      'menuHarianId': menuHarianId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
