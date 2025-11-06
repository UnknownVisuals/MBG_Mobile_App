class DapurPengirimanModel {
  DapurPengirimanModel({
    required this.id,
    required this.qrCodeId,
    required this.qrCodeUrl,
    required this.jumlahTray,
    required this.jumlahKeranjang,
    required this.status,
    required this.waktuBuatQR,
    this.waktuScanDriver,
    this.waktuSampai,
    required this.createdAt,
    required this.updatedAt,
    required this.sekolahId,
    this.driverId,
    this.picSekolahId,
    required this.sekolah,
  });

  final String id;
  final String qrCodeId;
  final String qrCodeUrl;
  final int jumlahTray;
  final int jumlahKeranjang;
  final String status;
  final DateTime waktuBuatQR;
  DateTime? waktuScanDriver;
  DateTime? waktuSampai;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sekolahId;
  String? driverId;
  String? picSekolahId;
  final DapurPengirimanSekolahSummary sekolah;

  factory DapurPengirimanModel.fromJson(Map<String, dynamic> json) {
    return DapurPengirimanModel(
      id: json['id'] as String,
      qrCodeId: (json['qrCodeId'] ?? '') as String,
      qrCodeUrl: (json['qrCodeUrl'] ?? '') as String,
      jumlahTray: _parseInt(json['jumlahTray']),
      jumlahKeranjang: _parseInt(json['jumlahKeranjang']),
      status: (json['status'] ?? '') as String,
      waktuBuatQR: _parseDateTime(json['waktuBuatQR']),
      waktuScanDriver: _parseNullableDateTime(json['waktuScanDriver']),
      waktuSampai: _parseNullableDateTime(json['waktuSampai']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      sekolahId: (json['sekolahId'] ?? '') as String,
      driverId: json['driverId'] as String?,
      picSekolahId: json['picSekolahId'] as String?,
      sekolah: DapurPengirimanSekolahSummary.fromJson(
        (json['sekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCodeId': qrCodeId,
      'qrCodeUrl': qrCodeUrl,
      'jumlahTray': jumlahTray,
      'jumlahKeranjang': jumlahKeranjang,
      'status': status,
      'waktuBuatQR': waktuBuatQR.toIso8601String(),
      'waktuScanDriver': waktuScanDriver?.toIso8601String(),
      'waktuSampai': waktuSampai?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sekolahId': sekolahId,
      'driverId': driverId,
      'picSekolahId': picSekolahId,
      'sekolah': sekolah.toJson(),
    };
  }
}

class DapurPengirimanSekolahSummary {
  DapurPengirimanSekolahSummary({
    required this.id,
    required this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
    required this.provinceId,
    required this.regencyId,
    required this.province,
    required this.regency,
  });

  final String id;
  final String nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final String provinceId;
  final String regencyId;
  final DapurPengirimanProvinceSummary province;
  final DapurPengirimanRegencySummary regency;

  factory DapurPengirimanSekolahSummary.fromJson(Map<String, dynamic> json) {
    // Handle both create and get response formats
    // Create response includes alamat, latitude, longitude
    // Get response doesn't include these fields
    return DapurPengirimanSekolahSummary(
      id: (json['id'] ?? '') as String,
      nama: (json['nama'] ?? '') as String,
      alamat: json['alamat'] as String?,
      latitude: _parseNullableDouble(json['latitude']),
      longitude: _parseNullableDouble(json['longitude']),
      provinceId: (json['provinceId'] ?? '') as String,
      regencyId: (json['regencyId'] ?? '') as String,
      province: DapurPengirimanProvinceSummary.fromJson(
        (json['province'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      regency: DapurPengirimanRegencySummary.fromJson(
        (json['regency'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'provinceId': provinceId,
      'regencyId': regencyId,
      'province': province.toJson(),
      'regency': regency.toJson(),
    };
  }
}

class DapurPengirimanProvinceSummary {
  DapurPengirimanProvinceSummary({required this.id, required this.name});

  final String id;
  final String name;

  factory DapurPengirimanProvinceSummary.fromJson(Map<String, dynamic> json) {
    return DapurPengirimanProvinceSummary(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class DapurPengirimanRegencySummary {
  DapurPengirimanRegencySummary({
    required this.id,
    required this.name,
    required this.provinceId,
  });

  final String id;
  final String name;
  final String provinceId;

  factory DapurPengirimanRegencySummary.fromJson(Map<String, dynamic> json) {
    return DapurPengirimanRegencySummary(
      id: json['id'],
      name: json['name'],
      provinceId: json['provinceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'provinceId': provinceId};
  }
}

extension PengirimanModelExtension on DapurPengirimanModel {
  String? get sekolahNama => sekolah.nama;
  String? get sekolahAlamat => sekolah.alamat;
  double? get sekolahLatitude => sekolah.latitude;
  double? get sekolahLongitude => sekolah.longitude;
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
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value);
  }
  return DateTime.now();
}

DateTime? _parseNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.parse(value);
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
