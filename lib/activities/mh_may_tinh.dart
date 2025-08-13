import 'package:app_giau/services/calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChonFile(openedFromCalculator: true),
          settings: RouteSettings(name: 'ChonFile'),
        ));
        setState(() {
          controller.clear();
        });
      } else {
        await controller.evaluate();
        setState(() {
          // Nếu muốn show kết quả luôn trên input thì:
          controller.input = controller.result;
          controller.result = '';
        });
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
      resizeToAvoidBottomInset: false, // Chặn UI bị đẩy
      body: Stack(
        children: [
          Positioned(
            top: 200.h,
            right: 30.w,      // padding phải 30
            left: 30.w,       // padding trái 30
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                controller.input,
                style: TextStyle(fontSize: 50.sp, color: Colors.white),
                maxLines: 1,
                minFontSize: 20.sp,
                maxFontSize: 50.sp,
                overflow: TextOverflow.ellipsis,
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
                        onPressed: () async {
                          if (e == '=') {
                            await onEqual(); // onEqual sẽ gọi evaluate()
                            setState(() {});
                          } else if (e == 'C') {
                            setState(() {
                              controller.clear();
                            });
                          } else if (e == '[X]') {
                            setState(() {
                              controller.backspace();
                            });
                          } else {
                            await controller.pressKey(e);
                            setState(() {});
                          }
                        }
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
