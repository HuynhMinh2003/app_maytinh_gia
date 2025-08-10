import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (label == 'C' || label == '[X]') {
      bgColor = Colors.redAccent;
      textColor = Colors.white;
    } else if (label == '=') {
      bgColor = Colors.greenAccent.shade400;
      textColor = Colors.black;
    } else if (['+', '-', '*', '/', '%'].contains(label)) {
      bgColor = Colors.blueAccent;
      textColor = Colors.white;
    } else {
      bgColor = Colors.grey.shade300;
      textColor = Colors.black87;
    }

    return SizedBox(
      height: 60.h,
      width: 80.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 5,
          shadowColor: Colors.black54,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: textColor,
            fontFamily: "Oswald",
          ),
        ),
      ),
    );
  }
}
