import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../api_response.dart';

import 'login_response_model.dart';

class AuthRepository {
  final API apiClient;

  AuthRepository({required this.apiClient});

  Future<ApiResponse<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: response.data['message'],
          data: LoginResponseModel.fromJson(response.data),
        );
      }

      return ApiResponse(success: false, message: response.data['message']);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }

  Future<ApiResponse<LoginResponseModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/register',
        data: {'username': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'],
          data: LoginResponseModel.fromJson(response.data),
        );
      }

      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Registration failed',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
