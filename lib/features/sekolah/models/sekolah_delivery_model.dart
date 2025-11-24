import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class SekolahDeliveryModel {
  SekolahDeliveryModel({
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
    this.driver,
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
  final String? driverId;
  final String? picSekolahId;
  final SekolahDeliverySekolahSummary sekolah;
  final SekolahDeliveryDriverSummary? driver;

  factory SekolahDeliveryModel.fromJson(Map<String, dynamic> json) {
    return SekolahDeliveryModel(
      id: (json['id'] ?? '') as String,
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
      sekolah: SekolahDeliverySekolahSummary.fromJson(
        (json['sekolah'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      driver: json['driver'] is Map<String, dynamic>
          ? SekolahDeliveryDriverSummary.fromJson(
              json['driver'] as Map<String, dynamic>,
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
      if (driver != null) 'driver': driver!.toJson(),
    };
  }
}

class SekolahDeliverySekolahSummary {
  SekolahDeliverySekolahSummary({
    required this.id,
    required this.nama,
    this.alamat,
    required this.provinceId,
    required this.regencyId,
    required this.province,
    required this.regency,
  });

  final String id;
  final String nama;
  final String? alamat;
  final String provinceId;
  final String regencyId;
  final SekolahDeliveryProvinceSummary province;
  final SekolahDeliveryRegencySummary regency;

  factory SekolahDeliverySekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahDeliverySekolahSummary(
      id: (json['id'] ?? '') as String,
      nama: (json['nama'] ?? '') as String,
      alamat: json['alamat'] as String?,
      provinceId: (json['provinceId'] ?? '') as String,
      regencyId: (json['regencyId'] ?? '') as String,
      province: SekolahDeliveryProvinceSummary.fromJson(
        (json['province'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      regency: SekolahDeliveryRegencySummary.fromJson(
        (json['regency'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      if (alamat != null) 'alamat': alamat,
      'provinceId': provinceId,
      'regencyId': regencyId,
      'province': province.toJson(),
      'regency': regency.toJson(),
    };
  }
}

class SekolahDeliveryProvinceSummary {
  SekolahDeliveryProvinceSummary({required this.id, required this.name});

  final String id;
  final String name;

  factory SekolahDeliveryProvinceSummary.fromJson(Map<String, dynamic> json) {
    return SekolahDeliveryProvinceSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class SekolahDeliveryRegencySummary {
  SekolahDeliveryRegencySummary({
    required this.id,
    required this.name,
    required this.provinceId,
  });

  final String id;
  final String name;
  final String provinceId;

  factory SekolahDeliveryRegencySummary.fromJson(Map<String, dynamic> json) {
    return SekolahDeliveryRegencySummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      provinceId: (json['provinceId'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'provinceId': provinceId,
  };
}

class SekolahDeliveryDriverSummary {
  SekolahDeliveryDriverSummary({
    required this.id,
    required this.name,
    required this.phone,
    this.nomorKendaraan,
  });

  final String id;
  final String name;
  final String phone;
  final String? nomorKendaraan;

  factory SekolahDeliveryDriverSummary.fromJson(Map<String, dynamic> json) {
    return SekolahDeliveryDriverSummary(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      nomorKendaraan: json['nomorKendaraan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      if (nomorKendaraan != null) 'nomorKendaraan': nomorKendaraan,
    };
  }
}

enum SekolahDeliveryStatus { pending, inTransit, completed, other }

extension SekolahDeliveryStatusExtension on SekolahDeliveryModel {
  SekolahDeliveryStatus get normalizedStatus {
    switch (status.replaceAll('_', ' ').toUpperCase()) {
      case 'PENDING':
      case 'MENUNGGU PENGIRIMAN':
        return SekolahDeliveryStatus.pending;
      case 'SEDANG DIANTAR':
      case 'DIANTAR':
      case 'IN TRANSIT':
        return SekolahDeliveryStatus.inTransit;
      case 'TELAH SAMPAI':
      case 'DITERIMA':
      case 'SELESAI':
        return SekolahDeliveryStatus.completed;
      default:
        return SekolahDeliveryStatus.other;
    }
  }

  Color get statusColor {
    switch (normalizedStatus) {
      case SekolahDeliveryStatus.pending:
        return MBGColors.warning;
      case SekolahDeliveryStatus.inTransit:
        return MBGColors.primary;
      case SekolahDeliveryStatus.completed:
        return MBGColors.success;
      case SekolahDeliveryStatus.other:
        return MBGColors.textSecondary;
    }
  }

  String get statusLabel {
    switch (normalizedStatus) {
      case SekolahDeliveryStatus.pending:
        return 'Menunggu Pengiriman';
      case SekolahDeliveryStatus.inTransit:
        return 'Sedang Diantar';
      case SekolahDeliveryStatus.completed:
        return 'Selesai';
      case SekolahDeliveryStatus.other:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }
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
