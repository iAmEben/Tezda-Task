class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? refreshToken;
  final String? name;
  final String? email;
  final String? avatar;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.refreshToken,
    this.name,
    this.email,
    this.avatar,
  });
}