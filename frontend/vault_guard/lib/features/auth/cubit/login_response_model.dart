class LoginResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class UserModel {
  final String id;
  final String username;
  final String email;

  UserModel({required this.id, required this.username, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
