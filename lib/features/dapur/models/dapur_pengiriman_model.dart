class DapurPengirimanModel {
  DapurPengirimanModel({
    required this.id,
    this.qrCodeId,
    this.qrCodeUrl,
    this.jumlahTray,
    this.jumlahKeranjang,
    this.status,
    this.waktuBuatQR,
    this.waktuScanDriver,
    this.waktuSampai,
    this.createdAt,
    this.updatedAt,
    this.sekolahId,
    this.driverId,
    this.picSekolahId,
    this.sekolah,
  });

  final String id;
  final String? qrCodeId;
  final String? qrCodeUrl;
  final int? jumlahTray;
  final int? jumlahKeranjang;
  final String? status;
  final DateTime? waktuBuatQR;
  DateTime? waktuScanDriver;
  DateTime? waktuSampai;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sekolahId;
  String? driverId;
  String? picSekolahId;
  final DapurPengirimanSekolahSummary? sekolah;

  factory DapurPengirimanModel.fromJson(Map<String, dynamic> json) {
    return DapurPengirimanModel(
      id: json['id'] as String,
      qrCodeId: json['qrCodeId'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      jumlahTray: _parseInt(json['jumlahTray']),
      jumlahKeranjang: _parseInt(json['jumlahKeranjang']),
      status: json['status'] as String?,
      waktuBuatQR: _parseDateTime(json['waktuBuatQR']),
      waktuScanDriver: _parseNullableDateTime(json['waktuScanDriver']),
      waktuSampai: _parseNullableDateTime(json['waktuSampai']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      sekolahId: json['sekolahId'] as String?,
      driverId: json['driverId'] as String?,
      picSekolahId: json['picSekolahId'] as String?,
      sekolah: json['sekolah'] != null
          ? DapurPengirimanSekolahSummary.fromJson(
              (json['sekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (qrCodeId != null) 'qrCodeId': qrCodeId,
      if (qrCodeUrl != null) 'qrCodeUrl': qrCodeUrl,
      if (jumlahTray != null) 'jumlahTray': jumlahTray,
      if (jumlahKeranjang != null) 'jumlahKeranjang': jumlahKeranjang,
      if (status != null) 'status': status,
      if (waktuBuatQR != null) 'waktuBuatQR': waktuBuatQR!.toIso8601String(),
      if (waktuScanDriver != null)
        'waktuScanDriver': waktuScanDriver!.toIso8601String(),
      if (waktuSampai != null) 'waktuSampai': waktuSampai!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (sekolahId != null) 'sekolahId': sekolahId,
      if (driverId != null) 'driverId': driverId,
      if (picSekolahId != null) 'picSekolahId': picSekolahId,
      if (sekolah != null) 'sekolah': sekolah!.toJson(),
    };
  }
}

class DapurPengirimanSekolahSummary {
  DapurPengirimanSekolahSummary({
    required this.id,
    this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
    this.provinceId,
    this.regencyId,
    this.province,
    this.regency,
  });

  final String id;
  final String? nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final String? provinceId;
  final String? regencyId;
  final DapurPengirimanProvinceSummary? province;
  final DapurPengirimanRegencySummary? regency;

  factory DapurPengirimanSekolahSummary.fromJson(Map<String, dynamic> json) {
    // Handle both create and get response formats
    // Create response includes alamat, latitude, longitude
    // Get response doesn't include these fields
    return DapurPengirimanSekolahSummary(
      id: (json['id'] ?? '') as String,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      latitude: _parseNullableDouble(json['latitude']),
      longitude: _parseNullableDouble(json['longitude']),
      provinceId: json['provinceId'] as String?,
      regencyId: json['regencyId'] as String?,
      province: json['province'] != null
          ? DapurPengirimanProvinceSummary.fromJson(
              (json['province'] ?? <String, dynamic>{}) as Map<String, dynamic>,
            )
          : null,
      regency: json['regency'] != null
          ? DapurPengirimanRegencySummary.fromJson(
              (json['regency'] ?? <String, dynamic>{}) as Map<String, dynamic>,
            )
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
      if (province != null) 'province': province!.toJson(),
      if (regency != null) 'regency': regency!.toJson(),
    };
  }
}

class DapurPengirimanProvinceSummary {
  DapurPengirimanProvinceSummary({required this.id, this.name});

  final String id;
  final String? name;

  factory DapurPengirimanProvinceSummary.fromJson(Map<String, dynamic> json) {
    return DapurPengirimanProvinceSummary(
      id: json['id'],
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, if (name != null) 'name': name};
  }
}

class DapurPengirimanRegencySummary {
  DapurPengirimanRegencySummary({required this.id, this.name, this.provinceId});

  final String id;
  final String? name;
  final String? provinceId;

  factory DapurPengirimanRegencySummary.fromJson(Map<String, dynamic> json) {
    return DapurPengirimanRegencySummary(
      id: json['id'],
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

extension PengirimanModelExtension on DapurPengirimanModel {
  String? get sekolahNama => sekolah?.nama;
  String? get sekolahAlamat => sekolah?.alamat;
  double? get sekolahLatitude => sekolah?.latitude;
  double? get sekolahLongitude => sekolah?.longitude;
  DateTime? get waktuDiambil => waktuScanDriver;
  DateTime? get waktuDiterima => waktuSampai;
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

DateTime _parseDateTime(dynamic value) {
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value).toLocal();
  }
  return DateTime.now();
}

DateTime? _parseNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value).toLocal();
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
