import 'package:app_giau/activities/mh_may_tinh.dart';
import 'package:app_giau/services/nhap_pin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_giau/l10n/app_localizations.dart';

class NhapPinScreen extends StatelessWidget {
  final NhapPinService service = NhapPinService();

  final TextEditingController pin1Controller = TextEditingController();
  final TextEditingController pin2Controller = TextEditingController();

  NhapPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF022350),
        appBar: AppBar(
          backgroundColor: const Color(0xFF022350),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.app_title,
                style: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Image.asset("assets/picture/calculator.png"),
              SizedBox(height: 40.h),
              TextField(
                controller: pin1Controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enter_pin,
                  labelStyle: TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: pin2Controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.re_enter_pin,
                  labelStyle: TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await service.confirmPin(
                      context,
                      pin1Controller.text.trim(),
                      pin2Controller.text.trim(),
                    );
                    if (result) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Calculator()));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.confirm,
                    style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black,
                    fontFamily: "Oswald",
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
