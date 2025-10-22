import 'package:flutter/material.dart';
import 'package:tribun_app/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
      with SingleTickerProviderStateMixin{
        late AnimationController _animationController;
        late Animation<double> _fadeAnimation;
        late Animation<double> _scaleAnimation;

    @override
    void initState(){
      super.initState();
      _animationController = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this
      );

      _fadeAnimation = Tween<double> (
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut
      ));

      _scaleAnimation = Tween<double>(
        begin: 0.5,
        end: 1.0
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut
      ));

      _animationController.forward();

      // navigate to home screen after 3 seconds

      Future.delayed(Duration(seconds: 3), () {
        // Get.offAllNamed(Routes)
      });
    }

    @override 
    void dispose(){
      _animationController.dispose();
      super.dispose();
    }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow:[
                            BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: Offset(0 ,10)
                          )] 
                        ),
                        child: Icon(
                          Icons.newspaper,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'News App',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Stay Update with Latest new',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8)
                        ),
                      ),
                      SizedBox(height: 50),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                      )
                    ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}