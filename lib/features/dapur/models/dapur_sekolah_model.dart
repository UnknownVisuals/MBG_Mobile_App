class DapurSekolahModel {
  final String id;
  final String nama;
  final String alamat;
  final double latitude;
  final double longitude;
  final String provinceId;
  final String regencyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Province province;
  final Regency regency;
  final List<PicSekolah> picSekolah;
  final SekolahCount count;

  DapurSekolahModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.provinceId,
    required this.regencyId,
    required this.createdAt,
    required this.updatedAt,
    required this.province,
    required this.regency,
    required this.picSekolah,
    required this.count,
  });

  factory DapurSekolahModel.fromJson(Map<String, dynamic> json) {
    return DapurSekolahModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      provinceId: json['provinceId'] ?? '',
      regencyId: json['regencyId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      province: Province.fromJson(json['province'] ?? {}),
      regency: Regency.fromJson(json['regency'] ?? {}),
      picSekolah:
          (json['picSekolah'] as List<dynamic>?)
              ?.map((e) => PicSekolah.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      count: SekolahCount.fromJson(json['_count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'provinceId': provinceId,
      'regencyId': regencyId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'province': province.toJson(),
      'regency': regency.toJson(),
      'picSekolah': picSekolah.map((e) => e.toJson()).toList(),
      '_count': count.toJson(),
    };
  }
}

class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Regency {
  final String id;
  final String name;
  final String provinceId;

  Regency({required this.id, required this.name, required this.provinceId});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      provinceId: json['provinceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'provinceId': provinceId};
  }
}

class PicSekolah {
  final String id;
  final String name;
  final String email;
  final String phone;

  PicSekolah({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory PicSekolah.fromJson(Map<String, dynamic> json) {
    return PicSekolah(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}

class SekolahCount {
  final int siswa;
  final int kelas;
  final int dapurPelayanan;

  SekolahCount({
    required this.siswa,
    required this.kelas,
    required this.dapurPelayanan,
  });

  factory SekolahCount.fromJson(Map<String, dynamic> json) {
    return SekolahCount(
      siswa: json['siswa'] ?? 0,
      kelas: json['kelas'] ?? 0,
      dapurPelayanan: json['dapurPelayanan'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'siswa': siswa, 'kelas': kelas, 'dapurPelayanan': dapurPelayanan};
  }
}
