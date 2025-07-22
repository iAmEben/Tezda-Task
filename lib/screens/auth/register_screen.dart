import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/authProvider.dart';
import '../../routes/route.dart';


@RoutePage()
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                child: Image.network(
                  'https://picsum.photos/800/1200',
                  height: heightOfScreen,
                  width: widthOfScreen,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 40,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ListView(
                    children: [
                      const SizedBox(height: 36),
                      _buildProfileSelector(),
                      const SizedBox(height: 16),
                      _buildForm(),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) { 
                            final success = await ref.read(authProvider.notifier).register(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              context.router.replace(const ProductListRoute());
                              const SnackBar(content: Text('Registration Success'));
                            } else { // Handles registration failure
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Registration failed')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: () => context.router.replace(const LoginRoute()),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSelector() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.only(top: 28),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
            width: 1,
            color: Colors.black.withOpacity(0.5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(76)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 50),
            const Icon(
              Icons.person,
              size: 30,
              color: Colors.black54,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.upload,
                  size: 24,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
              filled: true,
              fillColor: Colors.white70,
            ),
            validator: (value) => value!.isEmpty ? 'Enter username' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: Colors.white70,
            ),
            validator: (value) => value!.isEmpty ? 'Enter email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              filled: true,
              fillColor: Colors.white70,
            ),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Enter password' : null,
          ),
        ],
      ),
    );
  }
}