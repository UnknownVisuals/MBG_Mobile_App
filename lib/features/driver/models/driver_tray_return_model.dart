import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class DriverTrayReturnModel {
  DriverTrayReturnModel({
    required this.id,
    required this.qrCodeId,
    this.qrCodeUrl, // Optional in list view
    required this.jumlahTray,
    this.jumlahTrayDiterimaDriver,
    this.jumlahTrayDiterimaDapur,
    required this.status,
    this.keterangan,
    required this.waktuSubmit,
    this.waktuPickupDriver,
    this.waktuSampaiDapur,
    this.createdAt,
    this.updatedAt,
    this.sekolahId,
    this.pengirimanId,
    this.driverId,
    this.picSekolahId,
    this.picDapurId,
    required this.sekolah,
    this.driver,
    required this.picSekolah,
    this.picDapur,
  });

  final String id;
  final String qrCodeId;
  final String? qrCodeUrl;
  final int jumlahTray;
  final int? jumlahTrayDiterimaDriver;
  final int? jumlahTrayDiterimaDapur;
  final String status;
  final String? keterangan;
  final DateTime waktuSubmit;
  final DateTime? waktuPickupDriver;
  final DateTime? waktuSampaiDapur;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sekolahId;
  final String? pengirimanId;
  final String? driverId;
  final String? picSekolahId;
  final String? picDapurId;
  final DriverTrayReturnSekolahSummary sekolah;
  final DriverTrayReturnDriverSummary? driver;
  final DriverTrayReturnPICSummary picSekolah;
  final DriverTrayReturnPICSummary? picDapur;

  factory DriverTrayReturnModel.fromJson(Map<String, dynamic> json) {
    return DriverTrayReturnModel(
      id: (json['id'] ?? '') as String,
      qrCodeId: (json['qrCodeId'] ?? '') as String,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      jumlahTray: _parseInt(json['jumlahTray']),
      jumlahTrayDiterimaDriver: _parseNullableInt(
        json['jumlahTrayDiterimaDriver'],
      ),
      jumlahTrayDiterimaDapur: _parseNullableInt(
        json['jumlahTrayDiterimaDapur'],
      ),
      status: (json['status'] ?? '') as String,
      keterangan: json['keterangan'] as String?,
      waktuSubmit: _parseDateTime(json['waktuSubmit']),
      waktuPickupDriver: _parseNullableDateTime(json['waktuPickupDriver']),
      waktuSampaiDapur: _parseNullableDateTime(json['waktuSampaiDapur']),
      createdAt: _parseNullableDateTime(json['createdAt']),
      updatedAt: _parseNullableDateTime(json['updatedAt']),
      sekolahId: json['sekolahId'] as String?,
      pengirimanId: json['pengirimanId'] as String?,
      driverId: json['driverId'] as String?,
      picSekolahId: json['picSekolahId'] as String?,
      picDapurId: json['picDapurId'] as String?,
      sekolah: DriverTrayReturnSekolahSummary.fromJson(
        (json['sekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      driver: json['driver'] is Map<String, dynamic>
          ? DriverTrayReturnDriverSummary.fromJson(
              json['driver'] as Map<String, dynamic>,
            )
          : null,
      picSekolah: DriverTrayReturnPICSummary.fromJson(
        (json['picSekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      picDapur: json['picDapur'] is Map<String, dynamic>
          ? DriverTrayReturnPICSummary.fromJson(
              json['picDapur'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCodeId': qrCodeId,
      if (qrCodeUrl != null) 'qrCodeUrl': qrCodeUrl,
      'jumlahTray': jumlahTray,
      if (jumlahTrayDiterimaDriver != null)
        'jumlahTrayDiterimaDriver': jumlahTrayDiterimaDriver,
      if (jumlahTrayDiterimaDapur != null)
        'jumlahTrayDiterimaDapur': jumlahTrayDiterimaDapur,
      'status': status,
      if (keterangan != null) 'keterangan': keterangan,
      'waktuSubmit': waktuSubmit.toIso8601String(),
      if (waktuPickupDriver != null)
        'waktuPickupDriver': waktuPickupDriver!.toIso8601String(),
      if (waktuSampaiDapur != null)
        'waktuSampaiDapur': waktuSampaiDapur!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (sekolahId != null) 'sekolahId': sekolahId,
      if (pengirimanId != null) 'pengirimanId': pengirimanId,
      if (driverId != null) 'driverId': driverId,
      if (picSekolahId != null) 'picSekolahId': picSekolahId,
      if (picDapurId != null) 'picDapurId': picDapurId,
      'sekolah': sekolah.toJson(),
      if (driver != null) 'driver': driver!.toJson(),
      'picSekolah': picSekolah.toJson(),
      if (picDapur != null) 'picDapur': picDapur!.toJson(),
    };
  }
}

class DriverTrayReturnSekolahSummary {
  DriverTrayReturnSekolahSummary({
    required this.id,
    required this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;

  factory DriverTrayReturnSekolahSummary.fromJson(Map<String, dynamic> json) {
    return DriverTrayReturnSekolahSummary(
      id: (json['id'] ?? '') as String,
      nama: (json['nama'] ?? '') as String,
      alamat: json['alamat'] as String?,
      latitude: _parseNullableDouble(json['latitude']),
      longitude: _parseNullableDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class DriverTrayReturnDriverSummary {
  DriverTrayReturnDriverSummary({
    required this.id,
    required this.name,
    this.nomorKendaraan,
    this.driverOf,
  });

  final String id;
  final String name;
  final String? nomorKendaraan;
  final DriverTrayReturnDapurSummary? driverOf;

  factory DriverTrayReturnDriverSummary.fromJson(Map<String, dynamic> json) {
    return DriverTrayReturnDriverSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      nomorKendaraan: json['nomorKendaraan'] as String?,
      driverOf: json['driverOf'] != null
          ? DriverTrayReturnDapurSummary.fromJson(
              json['driverOf'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nomorKendaraan != null) 'nomorKendaraan': nomorKendaraan,
      if (driverOf != null) 'driverOf': driverOf!.toJson(),
    };
  }
}

class DriverTrayReturnDapurSummary {
  DriverTrayReturnDapurSummary({
    required this.id,
    required this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;

  factory DriverTrayReturnDapurSummary.fromJson(Map<String, dynamic> json) {
    return DriverTrayReturnDapurSummary(
      id: (json['id'] ?? '') as String,
      nama: (json['nama'] ?? '') as String,
      alamat: json['alamat'] as String?,
      latitude: _parseNullableDouble(json['latitude']),
      longitude: _parseNullableDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}

class DriverTrayReturnPICSummary {
  DriverTrayReturnPICSummary({
    required this.id,
    required this.name,
    this.email,
  });

  final String id;
  final String name;
  final String? email;

  factory DriverTrayReturnPICSummary.fromJson(Map<String, dynamic> json) {
    return DriverTrayReturnPICSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (email != null) 'email': email};
  }
}

enum DriverTrayReturnStatus { menungguPickup, sedangReturn, sampaiDapur, other }

extension DriverTrayReturnStatusExtension on DriverTrayReturnModel {
  DriverTrayReturnStatus get normalizedStatus {
    switch (status.replaceAll('_', ' ').toUpperCase()) {
      case 'MENUNGGU PICKUP':
        return DriverTrayReturnStatus.menungguPickup;
      case 'SEDANG RETURN':
        return DriverTrayReturnStatus.sedangReturn;
      case 'SAMPAI DAPUR':
        return DriverTrayReturnStatus.sampaiDapur;
      default:
        return DriverTrayReturnStatus.other;
    }
  }

  Color get statusColor {
    switch (normalizedStatus) {
      case DriverTrayReturnStatus.menungguPickup:
        return MBGColors.warning;
      case DriverTrayReturnStatus.sedangReturn:
        return MBGColors.primary;
      case DriverTrayReturnStatus.sampaiDapur:
        return MBGColors.success;
      case DriverTrayReturnStatus.other:
        return MBGColors.textSecondary;
    }
  }

  String get statusLabel {
    switch (normalizedStatus) {
      case DriverTrayReturnStatus.menungguPickup:
        return 'Perlu Pickup';
      case DriverTrayReturnStatus.sedangReturn:
        return 'Sedang Diantar';
      case DriverTrayReturnStatus.sampaiDapur:
        return 'Selesai';
      case DriverTrayReturnStatus.other:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  String get summaryLabel {
    final trayCount = jumlahTrayDiterimaDriver ?? jumlahTray;
    return '$trayCount Tray';
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
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
