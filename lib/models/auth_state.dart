class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? userId;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.userId,
  });
}