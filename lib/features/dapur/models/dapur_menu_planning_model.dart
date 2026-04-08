class DapurMenuPlanningModel {
  DapurMenuPlanningModel({
    required this.id,
    this.mingguanKe,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.createdAt,
    this.updatedAt,
    this.dapurId,
    this.sekolahId,
    this.dapur,
    this.sekolah,
    this.count,
  });

  final String id;
  final int? mingguanKe;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? dapurId;
  final String? sekolahId;
  final DapurMenuPlanningDapurSummary? dapur;
  final DapurMenuPlanningSekolahSummary? sekolah;
  final Count? count;

  factory DapurMenuPlanningModel.fromJson(Map<String, dynamic> json) {
    return DapurMenuPlanningModel(
      id: json['id'] as String,
      mingguanKe: json['mingguanKe'] as int?,
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.tryParse(json['tanggalMulai'] as String)?.toLocal()
          : null,
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.tryParse(json['tanggalSelesai'] as String)?.toLocal()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)?.toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)?.toLocal()
          : null,
      dapurId: json['dapurId'] as String?,
      sekolahId: json['sekolahId'] as String?,
      dapur: json['dapur'] != null
          ? DapurMenuPlanningDapurSummary.fromJson(
              json['dapur'] as Map<String, dynamic>,
            )
          : null,
      sekolah: json['sekolah'] != null
          ? DapurMenuPlanningSekolahSummary.fromJson(
              json['sekolah'] as Map<String, dynamic>,
            )
          : null,
      count: json['_count'] != null
          ? Count.fromJson(json['_count'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (mingguanKe != null) 'mingguanKe': mingguanKe,
      if (tanggalMulai != null) 'tanggalMulai': tanggalMulai!.toIso8601String(),
      if (tanggalSelesai != null)
        'tanggalSelesai': tanggalSelesai!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (dapurId != null) 'dapurId': dapurId,
      if (sekolahId != null) 'sekolahId': sekolahId,
      if (dapur != null) 'dapur': dapur!.toJson(),
      if (sekolah != null) 'sekolah': sekolah!.toJson(),
      if (count != null) '_count': count!.toJson(),
    };
  }
}

class DapurMenuPlanningDapurSummary {
  DapurMenuPlanningDapurSummary({required this.id, this.nama});

  final String id;
  final String? nama;

  factory DapurMenuPlanningDapurSummary.fromJson(Map<String, dynamic> json) {
    return DapurMenuPlanningDapurSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, if (nama != null) 'nama': nama};
  }
}

class DapurMenuPlanningSekolahSummary {
  DapurMenuPlanningSekolahSummary({required this.id, this.nama});

  final String id;
  final String? nama;

  factory DapurMenuPlanningSekolahSummary.fromJson(Map<String, dynamic> json) {
    return DapurMenuPlanningSekolahSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, if (nama != null) 'nama': nama};
  }
}

class Count {
  Count({this.menuHarian});

  final int? menuHarian;

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(menuHarian: json['menuHarian'] as int);
  }

  Map<String, dynamic> toJson() {
    return {if (menuHarian != null) 'menuHarian': menuHarian};
  }
}
