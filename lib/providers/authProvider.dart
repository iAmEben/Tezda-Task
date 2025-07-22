import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/auth_state.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(sharedPreferencesProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferences _prefs;

  AuthNotifier(this._prefs) : super(AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final token = _prefs.getString('token');
    final refreshToken = _prefs.getString('refreshToken');
    if (token != null && refreshToken != null && isTokenValid()) {
      state = AuthState(isAuthenticated: true, token: token, refreshToken: refreshToken);
    }
  }

  bool isTokenValid() {
    final loginTimestamp = _prefs.getInt('loginTimestamp');
    if (loginTimestamp == null) return false;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final twentyDaysInMillis = 20 * 24 * 60 * 60 * 1000;
    return (currentTime - loginTimestamp) < twentyDaysInMillis;
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('https://api.escuelajs.co/api/v1/auth/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'email': email, 'password': password});
      if (kDebugMode) {
        print('Login POST Request:');
      }
      if (kDebugMode) {
        print('URL: $url');
      }
      if (kDebugMode) {
        print('Headers: $headers');
      }
      if (kDebugMode) {
        print('Body: $body');
      }
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (kDebugMode) {
        print('Login Response Status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Login Response Body: ${response.body}');
      }
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data == null || data['access_token'] == null || data['refresh_token'] == null) {
          print('Login error: Invalid response format');
          return false;
        }
        await _prefs.setString('token', data['access_token']);
        await _prefs.setString('refreshToken', data['refresh_token']);
        await _prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
        state = AuthState(
          isAuthenticated: true,
          token: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      }
      if (kDebugMode) {
        print('Login failed: ${response.statusCode}, ${response.body}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final url = Uri.parse('https://api.escuelajs.co/api/v1/users/');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name': username,
        'email': email,
        'password': password,
        'avatar': 'https://api.lorem.space/image/face?w=150&h=150',
      });
      if (kDebugMode) {
        print('Register POST Request:');
      }
      if (kDebugMode) {
        print('URL: $url');
      }
      if (kDebugMode) {
        print('Headers: $headers');
      }
      if (kDebugMode) {
        print('Body: $body');
      }
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (kDebugMode) {
        print('Register Response Status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Register Response Body: ${response.body}');
      }
      if (response.statusCode == 201) {
        return await login(email, password);
      }
      print('Register failed: ${response.statusCode}, ${response.body}');
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('token');
    await _prefs.remove('refreshToken');
    await _prefs.remove('loginTimestamp');
    state = AuthState();
  }
}