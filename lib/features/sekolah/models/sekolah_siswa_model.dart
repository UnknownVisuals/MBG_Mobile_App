class SekolahSiswaPagination {
  SekolahSiswaPagination({this.total, this.page, this.limit, this.totalPages});

  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  factory SekolahSiswaPagination.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) => (value as num?)?.toInt();

    return SekolahSiswaPagination(
      total: toInt(json['total']),
      page: toInt(json['page']),
      limit: toInt(json['limit']),
      totalPages: toInt(json['totalPages']),
    );
  }
}

class SekolahSiswaPaginatedResponse {
  SekolahSiswaPaginatedResponse({required this.data, this.pagination});

  final List<SekolahSiswaModel> data;
  final SekolahSiswaPagination? pagination;
}

class SekolahSiswaModel {
  SekolahSiswaModel({
    required this.id,
    this.nama,
    this.nis,
    this.jenisKelamin,
    this.umur,
    this.tinggiBadan,
    this.beratBadan,
    this.imt,
    this.statusGizi,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
    required this.sekolahId,
    required this.kelasId,
    this.sekolah,
    this.kelas,
    this.alergi,
  });

  String id;
  String? nama;
  String? nis;
  String? jenisKelamin;
  int? umur;
  double? tinggiBadan;
  double? beratBadan;
  double? imt;
  String? statusGizi;
  String? fotoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  String sekolahId;
  String kelasId;
  SekolahSiswaSekolahSummary? sekolah;
  SekolahSiswaKelasSummary? kelas;
  List<SekolahSiswaAlergiSummary>? alergi;

  factory SekolahSiswaModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    List<SekolahSiswaAlergiSummary>? parseAlergiList(dynamic value) {
      if (value == null || value is! List) return null;
      return value
          .map<SekolahSiswaAlergiSummary>(
            (e) =>
                SekolahSiswaAlergiSummary.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    return SekolahSiswaModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      nis: json['nis'] as String?,
      jenisKelamin: json['jenisKelamin'] as String?,
      umur: json['umur'] as int?,
      tinggiBadan: (json['tinggiBadan'] as num?)?.toDouble(),
      beratBadan: (json['beratBadan'] as num?)?.toDouble(),
      imt: (json['imt'] as num?)?.toDouble(),
      statusGizi: json['statusGizi'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
      sekolahId: json['sekolahId'] as String,
      kelasId: json['kelasId'] as String,
      sekolah: json['sekolah'] != null
          ? SekolahSiswaSekolahSummary.fromJson(
              json['sekolah'] as Map<String, dynamic>,
            )
          : null,
      kelas: json['kelas'] != null
          ? SekolahSiswaKelasSummary.fromJson(
              json['kelas'] as Map<String, dynamic>,
            )
          : null,
      alergi: parseAlergiList(json['alergi']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nis': nis,
      'jenisKelamin': jenisKelamin,
      'umur': umur,
      'tinggiBadan': tinggiBadan,
      'beratBadan': beratBadan,
      'imt': imt,
      'statusGizi': statusGizi,
      'fotoUrl': fotoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sekolahId': sekolahId,
      'kelasId': kelasId,
      if (sekolah != null) 'sekolah': sekolah!.toJson(),
      if (kelas != null) 'kelas': kelas!.toJson(),
      if (alergi != null) 'alergi': alergi!.map((e) => e.toJson()).toList(),
    };
  }
}

// ======================================================================

class SekolahSiswaSekolahSummary {
  SekolahSiswaSekolahSummary({required this.id, this.nama});

  final String id;
  final String? nama;

  factory SekolahSiswaSekolahSummary.fromJson(Map<String, dynamic> json) {
    return SekolahSiswaSekolahSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}

// ======================================================================

class SekolahSiswaKelasSummary {
  SekolahSiswaKelasSummary({required this.id, this.nama, this.tingkat});

  final String id;
  final String? nama;
  final int? tingkat;

  factory SekolahSiswaKelasSummary.fromJson(Map<String, dynamic> json) {
    return SekolahSiswaKelasSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      tingkat: json['tingkat'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'tingkat': tingkat};
  }
}

// ======================================================================

class SekolahSiswaAlergiSummary {
  SekolahSiswaAlergiSummary({required this.id, required this.namaAlergi});

  final String id;
  final String namaAlergi;

  factory SekolahSiswaAlergiSummary.fromJson(Map<String, dynamic> json) {
    return SekolahSiswaAlergiSummary(
      id: json['id'] as String,
      namaAlergi: json['namaAlergi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'namaAlergi': namaAlergi};
  }
}
