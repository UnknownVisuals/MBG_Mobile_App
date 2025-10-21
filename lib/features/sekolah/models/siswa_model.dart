class SiswaModel {
  final String id;
  final String nama;
  final String nis;
  final String jenisKelamin; // LAKI_LAKI, PEREMPUAN
  final int umur;
  final double tinggiBadan;
  final double beratBadan;
  final double imt; // Auto-calculated by API
  final String statusGizi; // Auto-calculated by API
  final String? fotoUrl;
  final List<dynamic>? alergi; // Array of allergies
  final String kelasId;
  final String? kelasNama;
  final String sekolahId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SiswaModel({
    required this.id,
    required this.nama,
    required this.nis,
    required this.jenisKelamin,
    required this.umur,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.imt,
    required this.statusGizi,
    this.fotoUrl,
    this.alergi,
    required this.kelasId,
    this.kelasNama,
    required this.sekolahId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      id: json['id'],
      nama: json['nama'],
      nis: json['nis'],
      jenisKelamin: json['jenisKelamin'],
      umur: json['umur'],
      tinggiBadan: (json['tinggiBadan'] as num).toDouble(),
      beratBadan: (json['beratBadan'] as num).toDouble(),
      imt: (json['imt'] as num).toDouble(),
      statusGizi: json['statusGizi'],
      fotoUrl: json['fotoUrl'],
      alergi: json['alergi'] as List<dynamic>?,
      kelasId: json['kelasId'],
      kelasNama: json['kelas']?['nama'],
      sekolahId: json['sekolahId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'alergi': alergi,
      'kelasId': kelasId,
      'sekolahId': sekolahId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
