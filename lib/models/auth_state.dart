class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? refreshToken;

  AuthState({this.isAuthenticated = false, this.token, this.refreshToken});
}