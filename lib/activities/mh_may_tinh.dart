import 'package:app_giau/services/calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom/calculator_button.dart';
import '../l10n/app_localizations.dart';
import 'chon_file.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final controller = CalculatorService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> onEqual() async {
    try {
      if (await controller.checkPin()) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChonFile()));
        setState(() {
          controller.clear();
        });
      } else {
        await controller.evaluate();
        setState(() {});
      }
    } catch (_) {
      setState(() {
        controller.result = AppLocalizations.of(context)!.calculationError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = [
      'C', '[X]', '00', '/',
      '7', '8', '9', '*',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '%', '0', '.', '='
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 80.h),
                  Text(controller.input, style: TextStyle(fontSize: 50.sp, color: Colors.white)),
                  SizedBox(height: 10.h),
                  Text(controller.result, style: TextStyle(fontSize: 50.sp, color: Colors.white)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Divider(thickness: 0.5, height: 1, color: Colors.white),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFF022350),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 20,
                    children: keys.map((e) => CalculatorButton(
                      label: e,
                      onPressed: () {
                        setState(() {
                          if (e == '=') {
                            onEqual();
                          } else if (e == 'C') {
                            controller.clear();
                          } else if (e == '[X]') {
                            controller.backspace();
                          } else {
                            controller.pressKey(e);
                          }
                        });
                      },
                    )).toList(),
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
