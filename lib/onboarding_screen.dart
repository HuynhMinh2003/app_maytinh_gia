import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'l10n/app_localizations.dart';
import 'activities/nhap_pin.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  /// Lưu key hoặc text
  final List<Map<String, String>> _pages = [
    {
      "image": "assets/picture/calculator.svg",
      "title": "welcome_1",
      "content1": "content_welcome_1",
      "content2": "content_welcome_2",
    },
    {
      "image": "assets/picture/picture2.svg",
      "title": "welcome_2",
      "content1": "content_welcome_3",
      "content2": "content_welcome_4",
    },
    {
      "image": "assets/picture/picture3.svg",
      "title": "welcome_3",
      "content1": "content_welcome_5",
      "content2": "content_welcome_6",
    },
  ];

  /// Hàm dịch theo key
  String _translate(BuildContext context, String key) {
    switch (key) {
      case "welcome_1":
        return AppLocalizations.of(context)!.welcome_1;
      case "content_welcome_1":
        return AppLocalizations.of(context)!.content_welcome_1;
      case "content_welcome_2":
        return AppLocalizations.of(context)!.content_welcome_2;
      case "welcome_2":
        return AppLocalizations.of(context)!.welcome_2;
      case "content_welcome_3":
        return AppLocalizations.of(context)!.content_welcome_3;
      case "content_welcome_4":
        return AppLocalizations.of(context)!.content_welcome_4;
      case "welcome_3":
        return AppLocalizations.of(context)!.welcome_3;
      case "content_welcome_5":
        return AppLocalizations.of(context)!.content_welcome_5;
      case "content_welcome_6":
        return AppLocalizations.of(context)!.content_welcome_6;
      default:
        return key; // Nếu không phải key, trả nguyên văn
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF022350),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022350),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        page["image"]!,
                        width: 190.h,
                        height: 190.w,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        _translate(context, page["title"]!),
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
                            _translate(context, page["content1"]!),
                            style: TextStyle(fontSize: 15.sp, color: Colors.white),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            _translate(context, page["content2"]!),
                            style: TextStyle(fontSize: 15.sp, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
                width: _currentIndex == index ? 16.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: SizedBox(
              width: double.infinity,
              height: 60.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentIndex == _pages.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NhapPinScreen()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  _currentIndex == _pages.length - 1
                      ? AppLocalizations.of(context)!.con_tinue
                      : AppLocalizations.of(context)!.con_tinue1,
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black,
                    fontFamily: "Oswald",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
