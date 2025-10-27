class MenuPlanningModel {
  MenuPlanningModel({
    required this.id,
    required this.mingguanKe,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.createdAt,
    required this.updatedAt,
    required this.sekolahId,
    required this.dapurId,
    required this.dapur,
    required this.sekolah,
    required this.count,
  });

  final String id;
  final int mingguanKe;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String sekolahId;
  final String dapurId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Dapur dapur;
  final Sekolah sekolah;
  final Count count;

  factory MenuPlanningModel.fromJson(Map<String, dynamic> json) {
    return MenuPlanningModel(
      id: json['id'],
      mingguanKe: json['mingguanKe'],
      tanggalMulai: DateTime.parse(json['tanggalMulai']),
      tanggalSelesai: DateTime.parse(json['tanggalSelesai']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sekolahId: json['sekolahId'],
      dapurId: json['dapurId'],
      dapur: Dapur.fromJson(json['dapur']),
      sekolah: Sekolah.fromJson(json['sekolah']),
      count: Count.fromJson(json['_count']),
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
      'sekolahId': sekolahId,
      'dapurId': dapurId,
      'dapur': dapur.toJson(),
      'sekolah': sekolah.toJson(),
      '_count': count.toJson(),
    };
  }
}

class Dapur {
  Dapur({required this.id, required this.nama});

  final String id;
  final String nama;

  factory Dapur.fromJson(Map<String, dynamic> json) {
    return Dapur(id: json['id'] as String, nama: json['nama'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}

class Sekolah {
  Sekolah({required this.id, required this.nama});

  final String id;
  final String nama;

  factory Sekolah.fromJson(Map<String, dynamic> json) {
    return Sekolah(id: json['id'] as String, nama: json['nama'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id, 'nama': nama};
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
