import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class DapurTrayReturnModel {
  DapurTrayReturnModel({
    required this.id,
    required this.qrCodeId,
    this.qrCodeUrl,
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
    this.sekolah,
    this.driver,
    this.picSekolah,
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
  final DapurTrayReturnSekolahSummary? sekolah;
  final DapurTrayReturnDriverSummary? driver;
  final DapurTrayReturnPICSummary? picSekolah;
  final DapurTrayReturnPICSummary? picDapur;

  factory DapurTrayReturnModel.fromJson(Map<String, dynamic> json) {
    return DapurTrayReturnModel(
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
      sekolah: json['sekolah'] != null
          ? DapurTrayReturnSekolahSummary.fromJson(
              json['sekolah'] as Map<String, dynamic>,
            )
          : null,
      driver: json['driver'] != null
          ? DapurTrayReturnDriverSummary.fromJson(
              json['driver'] as Map<String, dynamic>,
            )
          : null,
      picSekolah: json['picSekolah'] != null
          ? DapurTrayReturnPICSummary.fromJson(
              json['picSekolah'] as Map<String, dynamic>,
            )
          : null,
      picDapur: json['picDapur'] != null
          ? DapurTrayReturnPICSummary.fromJson(
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
      if (sekolah != null) 'sekolah': sekolah!.toJson(),
      if (driver != null) 'driver': driver!.toJson(),
      if (picSekolah != null) 'picSekolah': picSekolah!.toJson(),
      if (picDapur != null) 'picDapur': picDapur!.toJson(),
    };
  }
}

class DapurTrayReturnSekolahSummary {
  DapurTrayReturnSekolahSummary({
    required this.id,
    required this.nama,
    this.alamat,
  });

  final String id;
  final String nama;
  final String? alamat;

  factory DapurTrayReturnSekolahSummary.fromJson(Map<String, dynamic> json) {
    return DapurTrayReturnSekolahSummary(
      id: (json['id'] ?? '') as String,
      nama: (json['nama'] ?? '') as String,
      alamat: json['alamat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, if (alamat != null) 'alamat': alamat};
  }
}

class DapurTrayReturnDriverSummary {
  DapurTrayReturnDriverSummary({
    required this.id,
    required this.name,
    this.nomorKendaraan,
  });

  final String id;
  final String name;
  final String? nomorKendaraan;

  factory DapurTrayReturnDriverSummary.fromJson(Map<String, dynamic> json) {
    return DapurTrayReturnDriverSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      nomorKendaraan: json['nomorKendaraan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nomorKendaraan != null) 'nomorKendaraan': nomorKendaraan,
    };
  }
}

class DapurTrayReturnPICSummary {
  DapurTrayReturnPICSummary({required this.id, required this.name, this.email});

  final String id;
  final String name;
  final String? email;

  factory DapurTrayReturnPICSummary.fromJson(Map<String, dynamic> json) {
    return DapurTrayReturnPICSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (email != null) 'email': email};
  }
}

enum DapurTrayReturnStatus { menungguPickup, sedangReturn, sampaiDapur, other }

extension DapurTrayReturnStatusExtension on DapurTrayReturnModel {
  DapurTrayReturnStatus get normalizedStatus {
    switch (status.replaceAll('_', ' ').toUpperCase()) {
      case 'MENUNGGU PICKUP':
        return DapurTrayReturnStatus.menungguPickup;
      case 'SEDANG RETURN':
        return DapurTrayReturnStatus.sedangReturn;
      case 'SAMPAI DAPUR':
        return DapurTrayReturnStatus.sampaiDapur;
      default:
        return DapurTrayReturnStatus.other;
    }
  }

  Color get statusColor {
    switch (normalizedStatus) {
      case DapurTrayReturnStatus.menungguPickup:
        return MBGColors.warning;
      case DapurTrayReturnStatus.sedangReturn:
        return MBGColors.primary;
      case DapurTrayReturnStatus.sampaiDapur:
        return MBGColors.success;
      case DapurTrayReturnStatus.other:
        return MBGColors.textSecondary;
    }
  }

  String get statusLabel {
    switch (normalizedStatus) {
      case DapurTrayReturnStatus.menungguPickup:
        return 'Menunggu Driver';
      case DapurTrayReturnStatus.sedangReturn:
        return 'Sedang Diantar';
      case DapurTrayReturnStatus.sampaiDapur:
        return 'Diterima Dapur';
      case DapurTrayReturnStatus.other:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  String get summaryLabel {
    final trayCount =
        jumlahTrayDiterimaDapur ?? jumlahTrayDiterimaDriver ?? jumlahTray;
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
