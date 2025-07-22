import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tezda_task/values/colors.dart';
import 'package:tezda_task/values/styles.dart';

import '../../providers/authProvider.dart';
import '../../routes/route.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  // Controllers for email and password input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final heightOfScreen = MediaQuery.of(context).size.height;
    final widthOfScreen = MediaQuery.of(context).size.width;

    return GestureDetector(
      // Dismiss keyboard on tap outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Stack for background image and overlay
        body: Stack(
          children: [
            // Background image
            Positioned(
              top: 0,
              child: Image.asset(
                'assets/images/splash_screen.jpg',
                height: heightOfScreen,
                width: widthOfScreen,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 36,
              child: ListView(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 200),
                  _buildForm(context),
                  const SizedBox(height: 36),
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        child: Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: Styles.customTitleTextStyle(
            color: AppColors.primaryColor
          )
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.white70),
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[300]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
              validator: (value) => value!.isEmpty ? 'Enter email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.white70),
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[300]!),
                ),
              ),
              style: TextStyle(color: Colors.white),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Enter password' : null,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement ForgotPasswordScreen navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forgot Password not implemented')),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 48),
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            // Validate form inputs
            if (_formKey.currentState!.validate()) {
              // Attempt login using auth provider
              final success = await ref.read(authProvider.notifier).login(
                _emailController.text,
                _passwordController.text,
              );
              if (success) {
                // Navigate to product list screen on successful login
                context.router.replaceAll([const ProductListRoute()]);
              } else {
                // Show error message on login failure
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login failed')),
                );
              }
            }
          },
          child: const Text('Login'),
        ),
        const SizedBox(height: 60),
        // Register link
        TextButton(
          onPressed: () => context.router.push(const RegisterRoute()),
          child: SizedBox(
            width: 150,
            child: Column(
              children: [
                Text(
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 1,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}