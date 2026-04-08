class UserModel {
  UserModel({
    required this.id,
    this.email,
    this.name,
    this.phone,
    this.role,
    this.nomorKendaraan,
    this.dapurAsPIC,
    this.sekolahAsPIC,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? email;
  final String? name;
  final String? phone;
  final String? role;
  final String? nomorKendaraan;
  final List<UserDapurAsPIC>? dapurAsPIC;
  final List<UserSekolahAsPIC>? sekolahAsPIC;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dapurList = (json['dapurAsPIC'] as List<dynamic>?)
        ?.map((e) => UserDapurAsPIC.fromJson(e as Map<String, dynamic>))
        .toList();

    final sekolahList = (json['sekolahAsPIC'] as List<dynamic>?)
        ?.map((e) => UserSekolahAsPIC.fromJson(e as Map<String, dynamic>))
        .toList();

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      nomorKendaraan: json['nomorKendaraan'] as String?,
      dapurAsPIC: dapurList,
      sekolahAsPIC: sekolahList,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String).toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String).toLocal()
          : null,
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
      'dapurAsPIC': dapurAsPIC?.map((e) => e.toJson()).toList(),
      'sekolahAsPIC': sekolahAsPIC?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

// ============================================================

class UserDapurAsPIC {
  UserDapurAsPIC({required this.id, this.nama, this.alamat, this.status});

  final String id;
  final String? nama;
  final String? alamat;
  final String? status;

  factory UserDapurAsPIC.fromJson(Map<String, dynamic> json) {
    return UserDapurAsPIC(
      id: json['id'] as String,
      nama: (json['nama'] ?? json['name']) as String?,
      alamat: json['alamat'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'alamat': alamat, 'status': status};
  }
}

// ============================================================

class UserSekolahAsPIC {
  UserSekolahAsPIC({required this.id, this.nama, this.alamat});

  final String id;
  final String? nama;
  final String? alamat;

  factory UserSekolahAsPIC.fromJson(Map<String, dynamic> json) {
    return UserSekolahAsPIC(
      id: json['id'] as String,
      nama: (json['nama'] ?? json['name']) as String?,
      alamat: json['alamat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'alamat': alamat};
  }
}
