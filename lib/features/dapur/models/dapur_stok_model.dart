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

class StokModel {
  StokModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.stokKg,
    required this.dapurId,
    required this.createdAt,
    required this.updatedAt,
    this.dapur,
  });

  final String id;
  final String nama;
  final KategoriStok kategori;
  final double stokKg;
  final String dapurId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DapurSummary? dapur;

  String get kategoriLabel => kategori.label;

  factory StokModel.fromJson(Map<String, dynamic> json) {
    return StokModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kategori: parseKategoriStok(json['kategori'] as String),
      stokKg: (json['stokKg'] as num).toDouble(),
      dapurId: json['dapurId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dapur: json['dapur'] != null
          ? DapurSummary.fromJson(json['dapur'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori.apiValue,
      'stokKg': stokKg,
      'dapurId': dapurId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (dapur != null) 'dapur': dapur!.toJson(),
    };
  }
}

class DapurSummary {
  DapurSummary({required this.id, required this.nama});

  final String id;
  final String nama;

  factory DapurSummary.fromJson(Map<String, dynamic> json) {
    return DapurSummary(id: json['id'] as String, nama: json['nama'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}
