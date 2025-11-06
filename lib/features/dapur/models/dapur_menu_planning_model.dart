class DapurMenuPlanningModel {
  DapurMenuPlanningModel({
    required this.id,
    required this.mingguanKe,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.createdAt,
    required this.updatedAt,
    required this.dapurId,
    required this.sekolahId,
    required this.dapur,
    required this.sekolah,
    required this.count,
  });

  final String id;
  final int mingguanKe;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dapurId;
  final String sekolahId;
  final DapurMenuPlanningDapurSummary dapur;
  final DapurMenuPlanningSekolahSummary sekolah;
  final Count count;

  factory DapurMenuPlanningModel.fromJson(Map<String, dynamic> json) {
    return DapurMenuPlanningModel(
      id: json['id'] as String,
      mingguanKe: json['mingguanKe'] as int,
      tanggalMulai: DateTime.parse(json['tanggalMulai'] as String),
      tanggalSelesai: DateTime.parse(json['tanggalSelesai'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dapurId: json['dapurId'] as String,
      sekolahId: json['sekolahId'] as String,
      dapur: DapurMenuPlanningDapurSummary.fromJson(
        json['dapur'] as Map<String, dynamic>,
      ),
      sekolah: DapurMenuPlanningSekolahSummary.fromJson(
        json['sekolah'] as Map<String, dynamic>,
      ),
      count: json['_count'] != null
          ? Count.fromJson(json['_count'] as Map<String, dynamic>)
          : Count(menuHarian: 0), // Default to 0 if _count is not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mingguanKe': mingguanKe,
      'tanggalMulai': tanggalMulai.toIso8601String(),
      'tanggalSelesai': tanggalSelesai.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dapurId': dapurId,
      'sekolahId': sekolahId,
      'dapur': dapur.toJson(),
      'sekolah': sekolah.toJson(),
      '_count': count.toJson(),
    };
  }
}

class DapurMenuPlanningDapurSummary {
  DapurMenuPlanningDapurSummary({required this.id, required this.nama});

  final String id;
  final String nama;

  factory DapurMenuPlanningDapurSummary.fromJson(Map<String, dynamic> json) {
    return DapurMenuPlanningDapurSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}

class DapurMenuPlanningSekolahSummary {
  DapurMenuPlanningSekolahSummary({required this.id, required this.nama});

  final String id;
  final String nama;

  factory DapurMenuPlanningSekolahSummary.fromJson(Map<String, dynamic> json) {
    return DapurMenuPlanningSekolahSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}

class Count {
  Count({required this.menuHarian});

  final int menuHarian;

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(menuHarian: json['menuHarian'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'menuHarian': menuHarian};
  }
}
