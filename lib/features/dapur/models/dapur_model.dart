class DapurModel {
  DapurModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.status,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.picDapur = const [],
    this.drivers = const [],
    this.karyawan = const [],
    this.stokBahanBaku = const [],
    this.sekolahDilayani = const [],
    this.counts,
  });

  final String id;
  final String nama;
  final String alamat;
  final String status; // AKTIF, NONAKTIF
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DapurPersonSummary> picDapur;
  final List<DapurDriverSummary> drivers;
  final List<DapurKaryawanSummary> karyawan;
  final List<DapurStokSummary> stokBahanBaku;
  final List<DapurSekolahDilayani> sekolahDilayani;
  final DapurCounts? counts;

  factory DapurModel.fromJson(Map<String, dynamic> json) {
    List<DapurPersonSummary> parsePersons(String key) {
      final data = json[key];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(DapurPersonSummary.fromJson)
            .toList();
      }
      return const [];
    }

    List<DapurDriverSummary> parseDrivers() {
      final data = json['drivers'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(DapurDriverSummary.fromJson)
            .toList();
      }
      return const [];
    }

    List<DapurKaryawanSummary> parseKaryawan() {
      final data = json['karyawan'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(DapurKaryawanSummary.fromJson)
            .toList();
      }
      return const [];
    }

    List<DapurStokSummary> parseStok() {
      final data = json['stokBahanBaku'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(DapurStokSummary.fromJson)
            .toList();
      }
      return const [];
    }

    List<DapurSekolahDilayani> parseSekolah() {
      final data = json['sekolahDilayani'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(DapurSekolahDilayani.fromJson)
            .toList();
      }
      return const [];
    }

    return DapurModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      status: json['status'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      picDapur: parsePersons('picDapur'),
      drivers: parseDrivers(),
      karyawan: parseKaryawan(),
      stokBahanBaku: parseStok(),
      sekolahDilayani: parseSekolah(),
      counts: json['_count'] is Map<String, dynamic>
          ? DapurCounts.fromJson(json['_count'] as Map<String, dynamic>)
          : null,
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
      if (counts != null) '_count': counts!.toJson(),
    };
  }
}

class DapurPersonSummary {
  DapurPersonSummary({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;

  factory DapurPersonSummary.fromJson(Map<String, dynamic> json) {
    return DapurPersonSummary(
      id: json['id'] as String,
      name: (json['name'] ?? json['nama']) as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}

class DapurDriverSummary extends DapurPersonSummary {
  DapurDriverSummary({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    this.nomorKendaraan,
  });

  final String? nomorKendaraan;

  factory DapurDriverSummary.fromJson(Map<String, dynamic> json) {
    return DapurDriverSummary(
      id: json['id'] as String,
      name: (json['name'] ?? json['nama']) as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      nomorKendaraan: json['nomorKendaraan'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'nomorKendaraan': nomorKendaraan};
  }
}

class DapurKaryawanSummary {
  DapurKaryawanSummary({
    required this.id,
    required this.nama,
    required this.posisi,
    this.status,
  });

  final String id;
  final String nama;
  final String posisi;
  final String? status;

  factory DapurKaryawanSummary.fromJson(Map<String, dynamic> json) {
    return DapurKaryawanSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
      posisi: json['posisi'] as String,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'posisi': posisi, 'status': status};
  }
}

class DapurStokSummary {
  DapurStokSummary({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.stokKg,
  });

  final String id;
  final String nama;
  final String kategori;
  final double stokKg;

  factory DapurStokSummary.fromJson(Map<String, dynamic> json) {
    return DapurStokSummary(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kategori: json['kategori'] as String,
      stokKg: (json['stokKg'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'kategori': kategori, 'stokKg': stokKg};
  }
}

class DapurSekolahDilayani {
  DapurSekolahDilayani({
    required this.id,
    required this.sekolahId,
    required this.createdAt,
    this.sekolah,
  });

  final String id;
  final String sekolahId;
  final DateTime createdAt;
  final SekolahSummary? sekolah;

  factory DapurSekolahDilayani.fromJson(Map<String, dynamic> json) {
    return DapurSekolahDilayani(
      id: json['id'] as String,
      sekolahId: json['sekolahId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sekolah: json['sekolah'] is Map<String, dynamic>
          ? SekolahSummary.fromJson(json['sekolah'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sekolahId': sekolahId,
      'createdAt': createdAt.toIso8601String(),
      if (sekolah != null) 'sekolah': sekolah!.toJson(),
    };
  }
}

class SekolahSummary {
  SekolahSummary({
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

  factory SekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahSummary(
      id: json['id'] as String,
      nama: (json['nama'] ?? json['name']) as String,
      alamat: json['alamat'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
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

class DapurCounts {
  DapurCounts({
    required this.karyawan,
    required this.stokBahanBaku,
    required this.sekolahDilayani,
  });

  final int karyawan;
  final int stokBahanBaku;
  final int sekolahDilayani;

  factory DapurCounts.fromJson(Map<String, dynamic> json) {
    return DapurCounts(
      karyawan: json['karyawan'] as int? ?? 0,
      stokBahanBaku: json['stokBahanBaku'] as int? ?? 0,
      sekolahDilayani: json['sekolahDilayani'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'karyawan': karyawan,
      'stokBahanBaku': stokBahanBaku,
      'sekolahDilayani': sekolahDilayani,
    };
  }
}
