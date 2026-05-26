abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);
}
