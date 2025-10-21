class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.nomorKendaraan,
    required this.dapurAsPIC,
    required this.sekolahAsPIC,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String phone;
  final String role;
  final String? nomorKendaraan;
  final List<AssignedDapur> dapurAsPIC;
  final List<AssignedSekolah> sekolahAsPIC;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dapurData = json['dapurAsPIC'] as List<dynamic>?;
    final sekolahData = json['sekolahAsPIC'] as List<dynamic>?;

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      nomorKendaraan: json['nomorKendaraan'] as String?,
      dapurAsPIC: dapurData == null
          ? <AssignedDapur>[]
          : dapurData
                .whereType<Map<String, dynamic>>()
                .map(AssignedDapur.fromJson)
                .toList(),
      sekolahAsPIC: sekolahData == null
          ? <AssignedSekolah>[]
          : sekolahData
                .whereType<Map<String, dynamic>>()
                .map(AssignedSekolah.fromJson)
                .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'nomorKendaraan': nomorKendaraan,
      'dapurAsPIC': dapurAsPIC.map((dapur) => dapur.toJson()).toList(),
      'sekolahAsPIC': sekolahAsPIC.map((sekolah) => sekolah.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AssignedDapur {
  AssignedDapur({
    required this.id,
    required this.nama,
    this.alamat,
    this.status,
  });

  final String id;
  final String nama;
  final String? alamat;
  final String? status;

  factory AssignedDapur.fromJson(Map<String, dynamic> json) {
    return AssignedDapur(
      id: json['id'] as String,
      nama: (json['nama'] ?? json['name']) as String,
      alamat: json['alamat'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'alamat': alamat, 'status': status};
  }
}

class AssignedSekolah {
  AssignedSekolah({required this.id, required this.nama, this.alamat});

  final String id;
  final String nama;
  final String? alamat;

  factory AssignedSekolah.fromJson(Map<String, dynamic> json) {
    return AssignedSekolah(
      id: json['id'] as String,
      nama: (json['nama'] ?? json['name']) as String,
      alamat: json['alamat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'alamat': alamat};
  }
}
