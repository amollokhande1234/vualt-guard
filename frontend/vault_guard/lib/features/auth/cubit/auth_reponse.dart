class AuthResponse {
  final bool success;
  final String message;
  final String? token;

  AuthResponse({required this.success, required this.message, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
