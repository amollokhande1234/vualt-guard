import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/secure_storage.dart/local_storage.dart';
import 'auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> login({required String email, required String password}) async {
    try {
      emit(const AuthLoading());

      final result = await _repository.login(email: email, password: password);

      emit(AuthSuccess(result.data!.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());

      final result = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      if (result.success) {
        await SecureStorageService.saveToken(result.data!.token);

        await SecureStorageService.saveUser(
          id: result.data!.user.id,
          username: result.data!.user.username,
          email: result.data!.user.email,
        );

        emit(AuthSuccess(result.message));
      }

      emit(AuthFailure(result.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
