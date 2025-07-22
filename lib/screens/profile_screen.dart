import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../providers/authProvider.dart';
import '../routes/route.dart';

@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const platform = MethodChannel('com.iameben.testmall/device');
  String deviceInfo = 'Fetching device info...';
  String name = 'John Williams';
  String email = 'john.williams@gmail.com';
  String avatar = 'https://picsum.photos/200';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
    _fetchProfile();
  }

  Future<void> _getDeviceInfo() async {
    try {
      final result = await platform.invokeMethod('getDeviceInfo');
      setState(() {
        deviceInfo = 'Device: ${result['modelName']}, iOS ${result['systemVersion']}';
      });
    } catch (e) {
      setState(() {
        deviceInfo = 'Device info not available';
      });
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        print('Profile fetch failed: No token found');
        setState(() => isLoading = false);
        return;
      }
      final url = Uri.parse('https://api.escuelajs.co/api/v1/auth/profile');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Profile GET Request:');
      print('URL: $url');
      print('Headers: $headers');
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      print('Profile Response Status: ${response.statusCode}');
      print('Profile Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? 'John Williams';
          email = data['email'] ?? 'john.williams@gmail.com';
          avatar = data['avatar'] ?? 'https://picsum.photos/200';
          isLoading = false;
        });
      } else {
        print('Profile fetch failed: ${response.statusCode}, ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Profile fetch error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                context.router.replace(const LoginRoute());
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                  minRadius: 60,
                  maxRadius: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  deviceInfo,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile Screen not implemented')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width / 3, 50),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}