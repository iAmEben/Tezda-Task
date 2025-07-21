import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routes/route.dart';


@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  // Animation controllers for image and text
  late AnimationController _imageController;
  late AnimationController _textController;
  // Animations for scaling image and text
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  // Flags to control animation start
  bool hasImageAnimationStarted = false;
  bool hasTextAnimationStarted = false;

  @override
  void initState() {
    super.initState();
    // Initialize image animation controller (500ms duration)
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Initialize text animation controller (500ms duration)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Define image scaling animation (1 to 1.5)
    _imageAnimation = Tween<double>(begin: 1, end: 1.5).animate(_imageController);
    // Define text scaling animation (3 to 0.5)
    _textAnimation = Tween<double>(begin: 3, end: 0.5).animate(_textController);
    // Add listeners for animation events
    _imageController.addListener(_imageControllerListener);
    _textController.addListener(_textControllerListener);
    // Start animation sequence
    _run();
  }

  // Listener for image animation completion
  void _imageControllerListener() {
    if (_imageController.status == AnimationStatus.completed) {
      // Start text animation after 1-second delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() => hasTextAnimationStarted = true);
          _textController.forward();
        }
      });
    }
  }

  // Listener for text animation completion
  void _textControllerListener() {
    if (_textController.status == AnimationStatus.completed) {
      // Navigate to LoginScreen after 1-second delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          context.router.replace(const LoginRoute());
        }
      });
    }
  }

  // Start image animation after 800ms delay
  void _run() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => hasImageAnimationStarted = true);
        _imageController.forward();
      }
    });
  }

  @override
  void dispose() {
    // Clean up animation controllers
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack for layering image and text
      body: Stack(
        children: [
          // Animated image with scaling and rotation
          AnimatedBuilder(
            animation: _imageController,
            child: Image.asset(
              'assets/images/splash_image.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            builder: (context, child) => RotationTransition(
              turns: hasImageAnimationStarted
                  ? Tween(begin: 0.0, end: 0.025).animate(_imageController)
                  : Tween(begin: 180.0, end: 0.02).animate(_imageController),
              child: Transform.scale(
                scale: _imageAnimation.value,
                child: child,
              ),
            ),
          ),
          // Animated text shown after image animation
          if (hasTextAnimationStarted)
            Center(
              child: AnimatedBuilder(
                animation: _textController,
                child: Text(
                  'TestMall',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontFamily: 'Roboto',
                    color: Colors.blue[900],
                  ),
                ),
                builder: (context, child) => Transform.scale(
                  scale: _textAnimation.value,
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            ),
        ],
      ),
    );
  }
}