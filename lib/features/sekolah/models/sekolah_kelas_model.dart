class SekolahKelasModel {
  SekolahKelasModel({
    required this.id,
    this.nama,
    this.tingkat,
    this.jumlahSiswa,
    required this.sekolahId,
    this.createdAt,
    this.updatedAt,
    this.sekolah,
    this.count,
  });

  final String id;
  final String? nama;
  final int? tingkat;
  final int? jumlahSiswa;
  final String sekolahId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SekolahKelasSekolahSummary? sekolah;
  final SekolahKelasCount? count;

  factory SekolahKelasModel.fromJson(Map<String, dynamic> json) {
    final countJson = json['_count'] as Map<String, dynamic>?;
    final count = countJson != null
        ? SekolahKelasCount.fromJson(countJson)
        : null;
    return SekolahKelasModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      tingkat: json['tingkat'] as int?,
      jumlahSiswa: count?.siswa,
      sekolahId: json['sekolahId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      sekolah: json['sekolah'] != null
          ? SekolahKelasSekolahSummary.fromJson(
              json['sekolah'] as Map<String, dynamic>,
            )
          : null,
      count: count,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'nama': nama,
      'tingkat': tingkat,
      'sekolahId': sekolahId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sekolah': sekolah?.toJson(),
    };

    if (count != null) {
      data['_count'] = count!.toJson();
    } else if (jumlahSiswa != null) {
      data['_count'] = {'siswa': jumlahSiswa};
    }

    return data;
  }
}

// ======================================================================

class SekolahKelasSekolahSummary {
  SekolahKelasSekolahSummary({
    required this.id,
    this.nama,
    this.provinceId,
    this.regencyId,
    this.province,
    this.regency,
  });

  String id;
  String? nama;
  String? provinceId;
  String? regencyId;
  SekolahKelasProvinceSummary? province;
  SekolahKelasRegencySummary? regency;

  factory SekolahKelasSekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahKelasSekolahSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      provinceId: json['provinceId'] as String?,
      regencyId: json['regencyId'] as String?,
      province: json['province'] != null
          ? SekolahKelasProvinceSummary.fromJson(
              json['province'] as Map<String, dynamic>,
            )
          : null,
      regency: json['regency'] != null
          ? SekolahKelasRegencySummary.fromJson(
              json['regency'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'id': id};
    if (nama != null) result['nama'] = nama;
    if (provinceId != null) result['provinceId'] = provinceId;
    if (regencyId != null) result['regencyId'] = regencyId;
    if (province != null) result['province'] = province!.toJson();
    if (regency != null) result['regency'] = regency!.toJson();
    return result;
  }
}

// ======================================================================

class SekolahKelasProvinceSummary {
  SekolahKelasProvinceSummary({required this.id, this.name});

  String id;
  String? name;

  factory SekolahKelasProvinceSummary.fromJson(Map<String, dynamic> json) {
    return SekolahKelasProvinceSummary(
      id: json['id'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'id': id};
    if (name != null) result['name'] = name;
    return result;
  }
}

// ======================================================================

class SekolahKelasRegencySummary {
  SekolahKelasRegencySummary({
    required this.id,
    required this.provinceId,
    this.name,
  });

  String id;
  String provinceId;
  String? name;

  factory SekolahKelasRegencySummary.fromJson(Map<String, dynamic> json) {
    return SekolahKelasRegencySummary(
      id: json['id'] as String,
      provinceId: json['provinceId'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'id': id, 'provinceId': provinceId};
    if (name != null) result['name'] = name;
    return result;
  }
}

// ======================================================================
class SekolahKelasCount {
  SekolahKelasCount({this.siswa});

  int? siswa;

  factory SekolahKelasCount.fromJson(Map<String, dynamic> json) {
    return SekolahKelasCount(siswa: json['siswa'] as int?);
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (siswa != null) result['siswa'] = siswa;
    return result;
  }
}
