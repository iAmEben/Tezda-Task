import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/authProvider.dart';
import '../routes/route.dart';

@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>{
  static const platform = MethodChannel('com.iameben.testmall/device');
  String deviceInfo = 'Fetching device info...';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                  minRadius: 60,
                  maxRadius: 60,
                ),
                const SizedBox(height: 8),
                const Text(
                  'John Williams',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'john.williams@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(deviceInfo,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.router.push(const EditProfileRoute()),
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
