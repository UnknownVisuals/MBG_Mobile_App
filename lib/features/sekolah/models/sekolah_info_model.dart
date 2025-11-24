class SekolahInfoModel {
  SekolahInfoModel({
    required this.id,
    required this.provinceId,
    required this.regencyId,
    this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.province,
    this.regency,
    this.picSekolah,
    this.kelas,
    this.dapurPelayanan,
    this.count,
  });

  String id;
  String provinceId;
  String regencyId;
  String? nama;
  String? alamat;
  double? latitude;
  double? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  SekolahInfoProvinceSummary? province;
  SekolahInfoRegencySummary? regency;
  List<SekolahInfoPICSekolahSummary>? picSekolah;
  List<SekolahInfoKelasSummary>? kelas;
  List<SekolahInfoDapurPelayananSummary>? dapurPelayanan;
  SekolahInfoCount? count;

  factory SekolahInfoModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) => (value as num).toDouble();

    return SekolahInfoModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      latitude: json['latitude'] != null ? toDouble(json['latitude']) : null,
      longitude: json['longitude'] != null ? toDouble(json['longitude']) : null,
      provinceId: json['provinceId'] as String,
      regencyId: json['regencyId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      province: json['province'] != null
          ? SekolahInfoProvinceSummary.fromJson(
              json['province'] as Map<String, dynamic>,
            )
          : null,
      regency: json['regency'] != null
          ? SekolahInfoRegencySummary.fromJson(
              json['regency'] as Map<String, dynamic>,
            )
          : null,
      picSekolah: (json['picSekolah'] as List<dynamic>?)
          ?.map(
            (item) => SekolahInfoPICSekolahSummary.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      kelas: (json['kelas'] as List<dynamic>?)
          ?.map(
            (item) =>
                SekolahInfoKelasSummary.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      dapurPelayanan: (json['dapurPelayanan'] as List<dynamic>?)
          ?.map(
            (item) => SekolahInfoDapurPelayananSummary.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      count: json['_count'] != null
          ? SekolahInfoCount.fromJson(json['_count'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'id': id,
      'provinceId': provinceId,
      'regencyId': regencyId,
    };
    if (nama != null) result['nama'] = nama;
    if (alamat != null) result['alamat'] = alamat;
    if (latitude != null) result['latitude'] = latitude;
    if (longitude != null) result['longitude'] = longitude;
    if (createdAt != null) result['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) result['updatedAt'] = updatedAt!.toIso8601String();
    if (province != null) result['province'] = province!.toJson();
    if (regency != null) result['regency'] = regency!.toJson();
    if (picSekolah != null) {
      result['picSekolah'] = picSekolah!.map((item) => item.toJson()).toList();
    }
    if (kelas != null) {
      result['kelas'] = kelas!.map((item) => item.toJson()).toList();
    }
    if (dapurPelayanan != null) {
      result['dapurPelayanan'] = dapurPelayanan!
          .map((item) => item.toJson())
          .toList();
    }
    if (count != null) result['_count'] = count!.toJson();
    return result;
  }
}

// ======================================================================

class SekolahInfoCount {
  SekolahInfoCount({this.siswa});

  int? siswa;

  factory SekolahInfoCount.fromJson(Map<String, dynamic> json) {
    return SekolahInfoCount(siswa: json['siswa'] as int?);
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (siswa != null) result['siswa'] = siswa;
    return result;
  }
}

// ======================================================================

class SekolahInfoProvinceSummary {
  SekolahInfoProvinceSummary({required this.id, this.name});

  String id;
  String? name;

  factory SekolahInfoProvinceSummary.fromJson(Map<String, dynamic> json) {
    return SekolahInfoProvinceSummary(
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

class SekolahInfoRegencySummary {
  SekolahInfoRegencySummary({
    required this.id,
    required this.provinceId,
    this.name,
  });

  String id;
  String provinceId;
  String? name;

  factory SekolahInfoRegencySummary.fromJson(Map<String, dynamic> json) {
    return SekolahInfoRegencySummary(
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

class SekolahInfoPICSekolahSummary {
  SekolahInfoPICSekolahSummary({
    required this.id,
    this.name,
    this.email,
    this.phone,
  });

  String id;
  String? name;
  String? email;
  String? phone;

  factory SekolahInfoPICSekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahInfoPICSekolahSummary(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'id': id};
    if (name != null) result['name'] = name;
    if (email != null) result['email'] = email;
    if (phone != null) result['phone'] = phone;
    return result;
  }
}

// ======================================================================

class SekolahInfoKelasSummary {
  SekolahInfoKelasSummary({
    required this.id,
    required this.sekolahId,
    this.nama,
    this.tingkat,
    this.createdAt,
    this.updatedAt,
    this.count,
  });

  String id;
  String sekolahId;
  String? nama;
  int? tingkat;
  DateTime? createdAt;
  DateTime? updatedAt;
  SekolahInfoKelasCount? count;

  factory SekolahInfoKelasSummary.fromJson(Map<String, dynamic> json) {
    return SekolahInfoKelasSummary(
      id: json['id'] as String,
      sekolahId: json['sekolahId'] as String,
      nama: json['nama'] as String?,
      tingkat: json['tingkat'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      count: json['_count'] != null
          ? SekolahInfoKelasCount.fromJson(
              json['_count'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'id': id, 'sekolahId': sekolahId};
    if (nama != null) result['nama'] = nama;
    if (tingkat != null) result['tingkat'] = tingkat;
    if (createdAt != null) result['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) result['updatedAt'] = updatedAt!.toIso8601String();
    if (count != null) result['_count'] = count!.toJson();
    return result;
  }
}

// ======================================================================

class SekolahInfoKelasCount {
  SekolahInfoKelasCount({this.siswa});

  int? siswa;

  factory SekolahInfoKelasCount.fromJson(Map<String, dynamic> json) {
    return SekolahInfoKelasCount(siswa: json['siswa'] as int?);
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (siswa != null) result['siswa'] = siswa;
    return result;
  }
}

// ======================================================================

class SekolahInfoDapurPelayananSummary {
  SekolahInfoDapurPelayananSummary({
    required this.id,
    required this.sekolahId,
    required this.dapurId,
    this.createdAt,
    this.dapur,
  });

  String id;
  String sekolahId;
  String dapurId;
  DateTime? createdAt;
  SekolahInfoDapur? dapur;

  factory SekolahInfoDapurPelayananSummary.fromJson(Map<String, dynamic> json) {
    return SekolahInfoDapurPelayananSummary(
      id: json['id'] as String,
      sekolahId: json['sekolahId'] as String,
      dapurId: json['dapurId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      dapur: json['dapur'] != null
          ? SekolahInfoDapur.fromJson(json['dapur'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'id': id,
      'sekolahId': sekolahId,
      'dapurId': dapurId,
    };
    if (createdAt != null) result['createdAt'] = createdAt!.toIso8601String();
    if (dapur != null) result['dapur'] = dapur!.toJson();
    return result;
  }
}

// ======================================================================

class SekolahInfoDapur {
  SekolahInfoDapur({
    required this.id,
    this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
  });

  String id;
  String? nama;
  String? alamat;
  double? latitude;
  double? longitude;

  factory SekolahInfoDapur.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) => (value as num).toDouble();

    return SekolahInfoDapur(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      latitude: json['latitude'] != null ? toDouble(json['latitude']) : null,
      longitude: json['longitude'] != null ? toDouble(json['longitude']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{'id': id};
    if (nama != null) result['nama'] = nama;
    if (alamat != null) result['alamat'] = alamat;
    if (latitude != null) result['latitude'] = latitude;
    if (longitude != null) result['longitude'] = longitude;
    return result;
  }
}
