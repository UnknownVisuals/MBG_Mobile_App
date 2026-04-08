class SekolahKalenderAkademikModel {
  SekolahKalenderAkademikModel({
    required this.id,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.deskripsi,
    this.createdAt,
    this.updatedAt,
    required this.sekolahId,
  });

  String id;
  DateTime? tanggalMulai;
  DateTime? tanggalSelesai;
  String? deskripsi;
  DateTime? createdAt;
  DateTime? updatedAt;
  String sekolahId;

  factory SekolahKalenderAkademikModel.fromJson(Map<String, dynamic> json) {
    return SekolahKalenderAkademikModel(
      id: json['id'] as String,
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.parse(json['tanggalMulai'] as String).toLocal()
          : null,
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'] as String).toLocal()
          : null,
      deskripsi: json['deskripsi'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String).toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String).toLocal()
          : null,
      sekolahId: json['sekolahId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggalMulai': tanggalMulai?.toIso8601String(),
      'tanggalSelesai': tanggalSelesai?.toIso8601String(),
      'deskripsi': deskripsi,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sekolahId': sekolahId,
    };
  }
}

class SekolahKalenderAkademikResponse {
  SekolahKalenderAkademikResponse({required this.kalenders, this.pagination});

  final List<SekolahKalenderAkademikModel> kalenders;
  final SekolahPagination? pagination;

  factory SekolahKalenderAkademikResponse.fromJson(Map<String, dynamic> json) {
    final kalenders =
        (json['kalenders'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map(SekolahKalenderAkademikModel.fromJson)
            .toList() ??
        <SekolahKalenderAkademikModel>[];

    return SekolahKalenderAkademikResponse(
      kalenders: kalenders,
      pagination: json['pagination'] != null
          ? SekolahPagination.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SekolahPagination {
  SekolahPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final int total;
  final int page;
  final int limit;
  final int totalPages;

  factory SekolahPagination.fromJson(Map<String, dynamic> json) {
    return SekolahPagination(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}
