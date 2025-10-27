class DapurInfoModel {
  DapurInfoModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.picDapur = const [],
    this.drivers = const [],
    this.karyawan = const [],
    this.stokBahanBaku = const [],
    this.sekolahDilayani = const [],
  });

  final String id;
  final String nama;
  final String alamat;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PICDapurSummary> picDapur;
  final List<DriversSummary> drivers;
  final List<KaryawanSummary> karyawan;
  final List<StockSummary> stokBahanBaku;
  final List<SekolahDilayaniSummary> sekolahDilayani;

  factory DapurInfoModel.fromJson(Map<String, dynamic> json) {
    return DapurInfoModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      status: json['status'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      picDapur:
          (json['picDapur'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(PICDapurSummary.fromJson)
              .toList() ??
          [],
      drivers:
          (json['drivers'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(DriversSummary.fromJson)
              .toList() ??
          [],
      karyawan:
          (json['karyawan'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(KaryawanSummary.fromJson)
              .toList() ??
          [],
      stokBahanBaku:
          (json['stokBahanBaku'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(StockSummary.fromJson)
              .toList() ??
          [],
      sekolahDilayani:
          (json['sekolahDilayani'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(SekolahDilayaniSummary.fromJson)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'picDapur': picDapur.map((pic) => pic.toJson()).toList(),
      'drivers': drivers.map((driver) => driver.toJson()).toList(),
      'karyawan': karyawan.map((item) => item.toJson()).toList(),
      'stokBahanBaku': stokBahanBaku.map((stok) => stok.toJson()).toList(),
      'sekolahDilayani': sekolahDilayani.map((item) => item.toJson()).toList(),
    };
  }
}

class PICDapurSummary {
  PICDapurSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  final String id;
  final String name;
  final String email;
  final String phone;

  factory PICDapurSummary.fromJson(Map<String, dynamic> json) {
    return PICDapurSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}

class DriversSummary {
  DriversSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nomorKendaraan,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String nomorKendaraan;

  factory DriversSummary.fromJson(Map<String, dynamic> json) {
    return DriversSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      nomorKendaraan: json['nomorKendaraan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'nomorKendaraan': nomorKendaraan,
    };
  }
}

class KaryawanSummary {
  KaryawanSummary({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.status,
  });

  final String id;
  final String nama;
  final String posisi;
  final String status;

  factory KaryawanSummary.fromJson(Map<String, dynamic> json) {
    return KaryawanSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
      posisi: json['posisi'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'posisi': posisi, 'status': status};
  }
}

class StockSummary {
  StockSummary({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.stokKg,
  });

  final String id;
  final String nama;
  final String kategori;
  final int stokKg;

  factory StockSummary.fromJson(Map<String, dynamic> json) {
    return StockSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kategori: json['kategori'] as String,
      stokKg: (json['stokKg'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'kategori': kategori, 'stokKg': stokKg};
  }
}

class SekolahDilayaniSummary {
  SekolahDilayaniSummary({
    required this.id,
    required this.sekolahId,
    required this.createdAt,
    required this.sekolah,
  });

  final String id;
  final String sekolahId;
  final DateTime createdAt;
  final SekolahSummary sekolah;

  factory SekolahDilayaniSummary.fromJson(Map<String, dynamic> json) {
    return SekolahDilayaniSummary(
      id: json['id'] as String,
      sekolahId: json['sekolahId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sekolah: SekolahSummary.fromJson(json['sekolah'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sekolahId': sekolahId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class SekolahSummary {
  SekolahSummary({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String nama;
  final String alamat;
  final double latitude;
  final double longitude;

  factory SekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
