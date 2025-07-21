import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(sharedPreferencesProvider));
});

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? userId;

  AuthState({this.isAuthenticated = false, this.token, this.userId});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferences _prefs;

  AuthNotifier(this._prefs) : super(AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final token = _prefs.getString('auth_token');
    final userId = _prefs.getString('user_id');
    if (token != null && userId != null) {
      state = AuthState(isAuthenticated: true, token: token, userId: userId);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _prefs.setString('auth_token', data['access_token']);
        await _prefs.setString('user_id', data['user']['id'].toString());
        state = AuthState(
          isAuthenticated: true,
          token: data['access_token'],
          userId: data['user']['id'].toString(),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/users/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'email': email,
          'password': password,
          'avatar': 'https://api.lorem.space/image/face?w=150&h=150'
        }),
      );

      if (response.statusCode == 201) {
        return await login(email, password);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_id');
    state = AuthState();
  }
}