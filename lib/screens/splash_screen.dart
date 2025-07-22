import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tezda_task/values/colors.dart';
import 'package:tezda_task/values/styles.dart';
import '../providers/authProvider.dart';
import '../routes/route.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  bool hasImageAnimationStarted = false;
  bool hasTextAnimationStarted = false;

  @override
  void initState() {
    super.initState();
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _imageAnimation = Tween<double>(begin: 1, end: 1.5).animate(_imageController);
    _textAnimation = Tween<double>(begin: 3, end: 0.5).animate(_textController);
    _imageController.addListener(_imageControllerListener);
    _textController.addListener(_textControllerListener);
    _run();
  }

  void _imageControllerListener() {
    if (_imageController.status == AnimationStatus.completed) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() => hasTextAnimationStarted = true);
          _textController.forward();
        }
      });
    }
  }

  void _textControllerListener() {
    if (_textController.status == AnimationStatus.completed) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          final authState = ref.read(authProvider);
          final isValid = ref.read(authProvider.notifier).isTokenValid();
          if (authState.isAuthenticated && isValid) {
            context.router.replaceAll([const ProductListRoute()]);
          } else {
            context.router.replaceAll([const LoginRoute()]);
          }
        }
      });
    }
  }

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
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          if (hasTextAnimationStarted)
            Center(
              child: AnimatedBuilder(
                animation: _textController,
                child: Text(
                  'TestMall',
                  style: Styles.customTitleTextStyle(
                    color: AppColors.primaryColor
                  )
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