import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  final LanguageService _controller = LanguageService();

  final List<Map<String, String>> languages = const [
    {'langCode': 'en', 'flagEmoji': '🇺🇸', 'text': 'English'},
    {'langCode': 'vi', 'flagEmoji': '🇻🇳', 'text': 'Tiếng Việt'},
    {'langCode': 'fr', 'flagEmoji': '🇫🇷', 'text': 'French'},
    {'langCode': 'zh', 'flagEmoji': '🇨🇳', 'text': 'Chinese'},
  ];

  String? selectedLangCode;

  @override
  void initState() {
    super.initState();
    _initLanguage();
  }

  Future<void> _initLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('lang_code') ?? 'en';
    setState(() {
      selectedLangCode = savedLang;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF022350),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022350),
        elevation: 0,
        title: Text(
          "Language",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                if (selectedLangCode != null) {
                  _controller.applyLanguage(context, selectedLangCode!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDD7000),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                width: 36.w,
                height: 36.w,
                child: const Icon(Icons.check, color: Colors.white, size: 24),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        color: const Color(0xFF022350),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          itemCount: languages.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final lang = languages[index];
            final isSelected = lang['langCode'] == selectedLangCode;

            return InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () => setState(() => selectedLangCode = lang['langCode']),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFF5E6) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFDD7000)
                        : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(lang['flagEmoji']!, style: TextStyle(fontSize: 24.sp)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        lang['text']!,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Radio<String>(
                      value: lang['langCode']!,
                      groupValue: selectedLangCode,
                      onChanged: (value) =>
                          setState(() => selectedLangCode = value),
                      activeColor: const Color(0xFFDD7000),
                    ),
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
