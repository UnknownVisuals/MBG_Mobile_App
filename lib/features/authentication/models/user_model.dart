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

  final String id, email, name, phone, role;
  final String? nomorKendaraan;
  final List<dynamic> dapurAsPIC, sekolahAsPIC;
  final DateTime createdAt, updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      nomorKendaraan: json['nomorKendaraan'],
      dapurAsPIC: json['dapurAsPIC'] ?? [],
      sekolahAsPIC: json['sekolahAsPIC'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'dapurAsPIC': dapurAsPIC,
      'sekolahAsPIC': sekolahAsPIC,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
