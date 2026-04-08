enum KategoriStok { SAYURAN, BUMBU, PROTEIN, KARBOHIDRAT, LAINNYA }

extension KategoriStokX on KategoriStok {
  String get apiValue => name;

  String get label {
    switch (this) {
      case KategoriStok.SAYURAN:
        return 'Sayuran';
      case KategoriStok.BUMBU:
        return 'Bumbu';
      case KategoriStok.PROTEIN:
        return 'Protein';
      case KategoriStok.KARBOHIDRAT:
        return 'Karbohidrat';
      case KategoriStok.LAINNYA:
        return 'Lainnya';
    }
  }
}

KategoriStok parseKategoriStok(String value) {
  switch (value.toUpperCase()) {
    case 'SAYURAN':
      return KategoriStok.SAYURAN;
    case 'BUMBU':
      return KategoriStok.BUMBU;
    case 'PROTEIN':
      return KategoriStok.PROTEIN;
    case 'KARBOHIDRAT':
      return KategoriStok.KARBOHIDRAT;
    default:
      return KategoriStok.LAINNYA;
  }
}

class DapurStokModel {
  DapurStokModel({
    required this.id,
    this.nama,
    this.kategori,
    this.stokKg,
    this.dapurId,
    this.createdAt,
    this.updatedAt,
    this.dapur,
  });

  final String id;
  final String? nama;
  final KategoriStok? kategori;
  final double? stokKg;
  final String? dapurId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DapurSummary? dapur;

  String? get kategoriLabel => kategori?.label;

  factory DapurStokModel.fromJson(Map<String, dynamic> json) {
    return DapurStokModel(
      id: json['id'] as String,
      nama: json['nama'] as String?,
      kategori: json['kategori'] != null
          ? parseKategoriStok(json['kategori'] as String)
          : null,
      stokKg: _parseNullableDouble(json['stokKg']),
      dapurId: json['dapurId'] as String?,
      createdAt: _parseNullableDateTime(json['createdAt']),
      updatedAt: _parseNullableDateTime(json['updatedAt']),
      dapur: json['dapur'] != null
          ? DapurSummary.fromJson(json['dapur'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (nama != null) 'nama': nama,
      if (kategori != null) 'kategori': kategori!.apiValue,
      if (stokKg != null) 'stokKg': stokKg,
      if (dapurId != null) 'dapurId': dapurId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (dapur != null) 'dapur': dapur!.toJson(),
    };
  }
}

class DapurSummary {
  DapurSummary({required this.id, this.nama});

  final String id;
  final String? nama;

  factory DapurSummary.fromJson(Map<String, dynamic> json) {
    return DapurSummary(
      id: json['id'] as String,
      nama: json['nama'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, if (nama != null) 'nama': nama};
  }
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String && value.isNotEmpty) {
    return double.tryParse(value);
  }
  return null;
}

DateTime? _parseNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value)?.toLocal();
  }
  return null;
}
