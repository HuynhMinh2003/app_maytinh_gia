import 'package:app_giau/activities/chon_ngon_ngu.dart';
import 'package:app_giau/services/pin_service.dart';
import 'package:flutter/material.dart';

import 'activities/mh_may_tinh.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 6000), () async {
      final pin = await PinService.getPin();

      if (pin != null && pin.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Calculator(),
            settings: RouteSettings(name: 'CalculatorScreen'),
          ),
        );      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LanguageSelectionPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF022350),
      body: Center(
        child: Transform.scale(
          scale: 0.6,
          child: Lottie.asset('assets/animation/Calculator.json'),
        ),
      ),
    );
  }
}
