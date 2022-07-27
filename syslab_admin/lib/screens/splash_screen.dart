import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:syslab_admin/screens/home_page.dart';
import 'package:syslab_admin/utilities/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset("assets/images/image1.png",height:150, width:150),
          const SizedBox(height: 20),
          const Text('ADMIN', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Lottie.asset('assets/images/97930-loading.json',height:150, width:150)
      ]),
      backgroundColor: splashColor,
      nextScreen: (const HomePage()),
      splashIconSize: 400,
      duration: 4000,
      splashTransition: SplashTransition.slideTransition,
      animationDuration:const Duration(seconds: 1),
    );
  }
}
