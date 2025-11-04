class PengirimanModel {
  final String id;
  final String qrCodeId;
  final String
  status; // PENDING, IN_TRANSIT, MENUNGGU_PENGIRIMAN, SEDANG_DIJEMPUT, DIAMBIL, DITERIMA
  final DateTime? waktuDiambil;
  final DateTime? waktuDiterima;
  final int jumlahTray;
  final int jumlahKeranjang;
  final String sekolahId;
  final String? sekolahNama;
  final String? sekolahAlamat;
  final String dapurId;
  final String? driverId;
  final String? driverNama;
  final DateTime createdAt;
  final DateTime updatedAt;

  PengirimanModel({
    required this.id,
    required this.qrCodeId,
    required this.status,
    this.waktuDiambil,
    this.waktuDiterima,
    required this.jumlahTray,
    required this.jumlahKeranjang,
    required this.sekolahId,
    this.sekolahNama,
    this.sekolahAlamat,
    required this.dapurId,
    this.driverId,
    this.driverNama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PengirimanModel.fromJson(Map<String, dynamic> json) {
    return PengirimanModel(
      id: json['id'],
      qrCodeId: json['qrCodeId'],
      status: json['status'],
      waktuDiambil: json['waktuDiambil'] != null
          ? DateTime.parse(json['waktuDiambil'])
          : null,
      waktuDiterima: json['waktuDiterima'] != null
          ? DateTime.parse(json['waktuDiterima'])
          : null,
      jumlahTray: json['jumlahTray'],
      jumlahKeranjang: json['jumlahKeranjang'],
      sekolahId: json['sekolahId'],
      sekolahNama: json['sekolah']?['nama'],
      sekolahAlamat: json['sekolah']?['alamat'],
      dapurId: json['dapurId'],
      driverId: json['driverId'],
      driverNama: json['driver']?['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qrCodeId': qrCodeId,
      'status': status,
      'waktuDiambil': waktuDiambil?.toIso8601String(),
      'waktuDiterima': waktuDiterima?.toIso8601String(),
      'jumlahTray': jumlahTray,
      'jumlahKeranjang': jumlahKeranjang,
      'sekolahId': sekolahId,
      'dapurId': dapurId,
      'driverId': driverId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
