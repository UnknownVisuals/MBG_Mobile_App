class LoginModel {
  LoginModel({required this.email, required this.password});

  final String email, password;

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
