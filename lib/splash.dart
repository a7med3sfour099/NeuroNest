import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAF2FD),
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/onboarding');
        },
        behavior: HitTestBehavior.opaque, // to make the whole page clickable
        child: Center(
          child: Container(
            width: 376,
            height: 504,
            child: Image.asset('assets/splash/splash.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
