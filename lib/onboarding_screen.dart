import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'activities/nhap_pin.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF022350),
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/picture/calculator.svg',
              width: 190.h,
              height: 190.w,
            ),
            SizedBox(height: 20.h),
            Text(
              AppLocalizations.of(context)!.welcome,
              style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 28.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.content_welcome_1,
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppLocalizations.of(context)!.content_welcome_2,
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 80.h),
            SizedBox(
              width: double.infinity,
              height: 60.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NhapPinScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black45,
                ),
                child: Text(
                  AppLocalizations.of(context)!.con_tinue,
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black,
                    fontFamily: "Oswald",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
