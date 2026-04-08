class DapurInfoModel {
  DapurInfoModel({
    required this.id,
    this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.picDapur,
    this.drivers,
    this.karyawan,
    this.stokBahanBaku,
    this.sekolahDilayani,
  });

  final String id;
  final String? nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PICDapurSummary>? picDapur;
  final List<DriversSummary>? drivers;
  final List<KaryawanSummary>? karyawan;
  final List<StockSummary>? stokBahanBaku;
  final List<SekolahDilayaniSummary>? sekolahDilayani;

  factory DapurInfoModel.fromJson(Map<String, dynamic> json) {
    return DapurInfoModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)?.toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)?.toLocal()
          : null,
      picDapur: (json['picDapur'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(PICDapurSummary.fromJson)
          .toList(),
      drivers: (json['drivers'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(DriversSummary.fromJson)
          .toList(),
      karyawan: (json['karyawan'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(KaryawanSummary.fromJson)
          .toList(),
      stokBahanBaku: (json['stokBahanBaku'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(StockSummary.fromJson)
          .toList(),
      sekolahDilayani: (json['sekolahDilayani'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(SekolahDilayaniSummary.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (status != null) 'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (picDapur != null)
        'picDapur': picDapur!.map((pic) => pic.toJson()).toList(),
      if (drivers != null)
        'drivers': drivers!.map((driver) => driver.toJson()).toList(),
      if (karyawan != null)
        'karyawan': karyawan!.map((item) => item.toJson()).toList(),
      if (stokBahanBaku != null)
        'stokBahanBaku': stokBahanBaku!.map((stok) => stok.toJson()).toList(),
      if (sekolahDilayani != null)
        'sekolahDilayani': sekolahDilayani!
            .map((item) => item.toJson())
            .toList(),
    };
  }
}

class PICDapurSummary {
  PICDapurSummary({required this.id, this.name, this.email, this.phone});

  final String id;
  final String? name;
  final String? email;
  final String? phone;

  factory PICDapurSummary.fromJson(Map<String, dynamic> json) {
    return PICDapurSummary(
      id: json['id'] as String,
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

class DriversSummary {
  DriversSummary({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.nomorKendaraan,
  });

  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? nomorKendaraan;

  factory DriversSummary.fromJson(Map<String, dynamic> json) {
    return DriversSummary(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      nomorKendaraan: json['nomorKendaraan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (nomorKendaraan != null) 'nomorKendaraan': nomorKendaraan,
    };
  }
}

class KaryawanSummary {
  KaryawanSummary({required this.id, this.nama, this.posisi, this.status});

  final String id;
  final String? nama;
  final String? posisi;
  final String? status;

  factory KaryawanSummary.fromJson(Map<String, dynamic> json) {
    return KaryawanSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      posisi: json['posisi'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (posisi != null) 'posisi': posisi,
      if (status != null) 'status': status,
    };
  }
}

class StockSummary {
  StockSummary({required this.id, this.nama, this.kategori, this.stokKg});

  final String id;
  final String? nama;
  final String? kategori;
  final double? stokKg;

  factory StockSummary.fromJson(Map<String, dynamic> json) {
    return StockSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      kategori: json['kategori'] as String?,
      stokKg: (json['stokKg'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (kategori != null) 'kategori': kategori,
      if (stokKg != null) 'stokKg': stokKg,
    };
  }
}

class SekolahDilayaniSummary {
  SekolahDilayaniSummary({
    required this.id,
    this.createdAt,
    this.sekolahId,
    this.dapurId,
    this.sekolah,
  });

  final String id;
  final DateTime? createdAt;
  final String? sekolahId;
  final String? dapurId;
  final SekolahSummary? sekolah;

  factory SekolahDilayaniSummary.fromJson(Map<String, dynamic> json) {
    return SekolahDilayaniSummary(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)?.toLocal()
          : null,
      sekolahId: json['sekolahId'] as String?,
      dapurId: json['dapurId'] as String?,
      sekolah: json['sekolah'] != null
          ? SekolahSummary.fromJson(json['sekolah'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (sekolahId != null) 'sekolahId': sekolahId,
      if (dapurId != null) 'dapurId': dapurId,
      if (sekolah != null) 'sekolah': sekolah!.toJson(),
    };
  }
}

class SekolahSummary {
  SekolahSummary({
    required this.id,
    this.nama,
    this.alamat,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String? nama;
  final String? alamat;
  final double? latitude;
  final double? longitude;

  factory SekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      alamat: json['alamat'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}
