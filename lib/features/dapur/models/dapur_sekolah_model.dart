class DapurSekolahModel {
  DapurSekolahModel({
    required this.id,
    this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
    this.provinceId,
    this.regencyId,
    this.createdAt,
    this.updatedAt,
    this.province,
    this.regency,
    this.picSekolah,
    this.count,
  });

  final String id;
  final String? nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final String? provinceId;
  final String? regencyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Province? province;
  final Regency? regency;
  final List<PicSekolah>? picSekolah;
  final SekolahCount? count;

  factory DapurSekolahModel.fromJson(Map<String, dynamic> json) {
    return DapurSekolahModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      latitude: _parseNullableDouble(json['latitude']),
      longitude: _parseNullableDouble(json['longitude']),
      provinceId: json['provinceId'] as String?,
      regencyId: json['regencyId'] as String?,
      createdAt: _parseNullableDateTime(json['createdAt']),
      updatedAt: _parseNullableDateTime(json['updatedAt']),
      province: json['province'] != null
          ? Province.fromJson(json['province'] as Map<String, dynamic>)
          : null,
      regency: json['regency'] != null
          ? Regency.fromJson(json['regency'] as Map<String, dynamic>)
          : null,
      picSekolah: (json['picSekolah'] as List<dynamic>?)
          ?.map((e) => PicSekolah.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['_count'] != null
          ? SekolahCount.fromJson(json['_count'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (provinceId != null) 'provinceId': provinceId,
      if (regencyId != null) 'regencyId': regencyId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (province != null) 'province': province!.toJson(),
      if (regency != null) 'regency': regency!.toJson(),
      if (picSekolah != null)
        'picSekolah': picSekolah!.map((e) => e.toJson()).toList(),
      if (count != null) '_count': count!.toJson(),
    };
  }
}

class Province {
  Province({required this.id, this.name});

  final String id;
  final String? name;

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, if (name != null) 'name': name};
  }
}

class Regency {
  Regency({required this.id, this.name, this.provinceId});

  final String id;
  final String? name;
  final String? provinceId;

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      provinceId: json['provinceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (provinceId != null) 'provinceId': provinceId,
    };
  }
}

class PicSekolah {
  PicSekolah({required this.id, this.name, this.email, this.phone});

  final String id;
  final String? name;
  final String? email;
  final String? phone;

  factory PicSekolah.fromJson(Map<String, dynamic> json) {
    return PicSekolah(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}

class SekolahCount {
  SekolahCount({this.siswa, this.kelas, this.dapurPelayanan});

  final int? siswa;
  final int? kelas;
  final int? dapurPelayanan;

  factory SekolahCount.fromJson(Map<String, dynamic> json) {
    return SekolahCount(
      siswa: _parseNullableInt(json['siswa']),
      kelas: _parseNullableInt(json['kelas']),
      dapurPelayanan: _parseNullableInt(json['dapurPelayanan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (siswa != null) 'siswa': siswa,
      if (kelas != null) 'kelas': kelas,
      if (dapurPelayanan != null) 'dapurPelayanan': dapurPelayanan,
    };
  }
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String && value.isNotEmpty) {
    return int.tryParse(value);
  }
  return null;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String && value.isNotEmpty) {
    return double.tryParse(value);
  }
  return null;
}

DateTime? _parseNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value)?.toLocal();
  }
  return null;
}
