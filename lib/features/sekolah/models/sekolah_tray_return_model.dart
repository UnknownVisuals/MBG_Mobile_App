import 'package:flutter/material.dart';

import 'package:mbg_mobile_app/utils/constants/colors.dart';

class SekolahTrayReturnModel {
  SekolahTrayReturnModel({
    required this.id,
    required this.qrCodeId,
    required this.qrCodeUrl,
    required this.jumlahTray,
    this.jumlahTrayDiterimaDriver,
    this.jumlahTrayDiterimaDapur,
    required this.status,
    this.keterangan,
    required this.waktuSubmit,
    this.waktuPickupDriver,
    this.waktuSampaiDapur,
    required this.createdAt,
    required this.updatedAt,
    required this.sekolahId,
    required this.pengirimanId,
    this.driverId,
    required this.picSekolahId,
    this.picDapurId,
    required this.sekolah,
    this.driver,
    required this.picSekolah,
    this.picDapur,
  });

  final String id;
  final String qrCodeId;
  final String qrCodeUrl;
  final int jumlahTray;
  final int? jumlahTrayDiterimaDriver;
  final int? jumlahTrayDiterimaDapur;
  final String status;
  final String? keterangan;
  final DateTime waktuSubmit;
  final DateTime? waktuPickupDriver;
  final DateTime? waktuSampaiDapur;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sekolahId;
  final String pengirimanId;
  final String? driverId;
  final String picSekolahId;
  final String? picDapurId;
  final SekolahTrayReturnSekolahSummary sekolah;
  final SekolahTrayReturnDriverSummary? driver;
  final SekolahTrayReturnPICSummary picSekolah;
  final SekolahTrayReturnPICSummary? picDapur;

  factory SekolahTrayReturnModel.fromJson(Map<String, dynamic> json) {
    return SekolahTrayReturnModel(
      id: (json['id'] ?? '') as String,
      qrCodeId: (json['qrCodeId'] ?? '') as String,
      qrCodeUrl: (json['qrCodeUrl'] ?? '') as String,
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
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      sekolahId: (json['sekolahId'] ?? '') as String,
      pengirimanId: (json['pengirimanId'] ?? '') as String,
      driverId: json['driverId'] as String?,
      picSekolahId: (json['picSekolahId'] ?? '') as String,
      picDapurId: json['picDapurId'] as String?,
      sekolah: SekolahTrayReturnSekolahSummary.fromJson(
        (json['sekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      driver: json['driver'] is Map<String, dynamic>
          ? SekolahTrayReturnDriverSummary.fromJson(
              json['driver'] as Map<String, dynamic>,
            )
          : null,
      picSekolah: SekolahTrayReturnPICSummary.fromJson(
        (json['picSekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      picDapur: json['picDapur'] is Map<String, dynamic>
          ? SekolahTrayReturnPICSummary.fromJson(
              json['picDapur'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCodeId': qrCodeId,
      'qrCodeUrl': qrCodeUrl,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sekolahId': sekolahId,
      'pengirimanId': pengirimanId,
      if (driverId != null) 'driverId': driverId,
      'picSekolahId': picSekolahId,
      if (picDapurId != null) 'picDapurId': picDapurId,
      'sekolah': sekolah.toJson(),
      if (driver != null) 'driver': driver!.toJson(),
      'picSekolah': picSekolah.toJson(),
      if (picDapur != null) 'picDapur': picDapur!.toJson(),
    };
  }
}

class SekolahTrayReturnSekolahSummary {
  SekolahTrayReturnSekolahSummary({
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

  factory SekolahTrayReturnSekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahTrayReturnSekolahSummary(
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

class SekolahTrayReturnDriverSummary {
  SekolahTrayReturnDriverSummary({
    required this.id,
    required this.name,
    this.nomorKendaraan,
    this.nomorTelepon,
  });

  final String id;
  final String name;
  final String? nomorKendaraan;
  final String? nomorTelepon;

  factory SekolahTrayReturnDriverSummary.fromJson(Map<String, dynamic> json) {
    return SekolahTrayReturnDriverSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      nomorKendaraan: json['nomorKendaraan'] as String?,
      nomorTelepon: json['nomorTelepon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nomorKendaraan != null) 'nomorKendaraan': nomorKendaraan,
      if (nomorTelepon != null) 'nomorTelepon': nomorTelepon,
    };
  }
}

class SekolahTrayReturnPICSummary {
  SekolahTrayReturnPICSummary({
    required this.id,
    required this.name,
    this.email,
  });

  final String id;
  final String name;
  final String? email;

  factory SekolahTrayReturnPICSummary.fromJson(Map<String, dynamic> json) {
    return SekolahTrayReturnPICSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (email != null) 'email': email};
  }
}

enum SekolahTrayReturnStatus {
  menungguPickup,
  sedangReturn,
  sampaiDapur,
  other,
}

extension SekolahTrayReturnStatusExtension on SekolahTrayReturnModel {
  SekolahTrayReturnStatus get normalizedStatus {
    switch (status.replaceAll('_', ' ').toUpperCase()) {
      case 'MENUNGGU PICKUP':
        return SekolahTrayReturnStatus.menungguPickup;
      case 'SEDANG RETURN':
        return SekolahTrayReturnStatus.sedangReturn;
      case 'SAMPAI DAPUR':
        return SekolahTrayReturnStatus.sampaiDapur;
      default:
        return SekolahTrayReturnStatus.other;
    }
  }

  Color get statusColor {
    switch (normalizedStatus) {
      case SekolahTrayReturnStatus.menungguPickup:
        return MBGColors.warning;
      case SekolahTrayReturnStatus.sedangReturn:
        return MBGColors.primary;
      case SekolahTrayReturnStatus.sampaiDapur:
        return MBGColors.success;
      case SekolahTrayReturnStatus.other:
        return MBGColors.textSecondary;
    }
  }

  String get statusLabel {
    switch (normalizedStatus) {
      case SekolahTrayReturnStatus.menungguPickup:
        return 'Menunggu Pickup';
      case SekolahTrayReturnStatus.sedangReturn:
        return 'Sedang Diantar';
      case SekolahTrayReturnStatus.sampaiDapur:
        return 'Selesai';
      case SekolahTrayReturnStatus.other:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  String get summaryLabel {
    final trayCount = jumlahTray;
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

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String && value.isNotEmpty) {
    return double.tryParse(value);
  }
  return null;
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
