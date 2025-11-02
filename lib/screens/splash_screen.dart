import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _planeController;
  late Animation<Offset> _planeSlide;
  late AnimationController _fadeController;
  late Animation<double> _fadeLogo;

  @override
  void initState() {
    super.initState();

    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), 
    );

    _planeSlide = Tween<Offset>(
      begin: const Offset(-1.8, 1.0),
      end: const Offset(4.9, -3.9),
    ).animate(CurvedAnimation(
      parent: _planeController,
      curve: Curves.bounceInOut,
    ));

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeLogo = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _planeController.forward().then((_) => _fadeController.forward());


    Future.delayed(const Duration(seconds: 7), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void dispose() {
    _planeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SlideTransition(
              position: _planeSlide,
              child: Transform.rotate(
                angle: -0.2,
                child: Image.asset(
                  'assets/image/plane.png',
                  width: 80,
                ),
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeLogo,
              child: ScaleTransition(
                scale: _fadeLogo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/logo.png',
                      width: 400,
                      height: 200,
                    ),
                    SizedBox(height: 180),
                    Image.asset(
                      'assets/image/font.png',
                      width: 170,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
