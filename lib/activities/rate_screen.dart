// rate_dialog_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../l10n/app_localizations.dart';
import '../services/rate_service.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({Key? key}) : super(key: key);

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final rateService = RateService();
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _loadRating();
  }

  void _loadRating() async {
    final saved = await rateService.getRating();
    setState(() {
      _rating = saved;
    });
  }

  void _submitRating() async {
    await rateService.saveRating(_rating);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.rate_info,style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,),
    );
    Navigator.of(context).pop(); // đóng dialog
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/picture/star.svg',
          width: 100,
          height: 100,
        ),
        Text(
          AppLocalizations.of(context)!.title_rate,
          style: TextStyle(fontSize: 20.sp,color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.content_rate,
          style: TextStyle(fontSize: 15.sp,color:Colors.grey),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
        SizedBox(height: 10.h),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
          TextButton(
            onPressed: (){Navigator.of(context,rootNavigator: true).pop();},
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color:Colors.black, fontSize: 15.sp)),
          ),
          ElevatedButton(
            onPressed: _submitRating,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(AppLocalizations.of(context)!.rated, style: TextStyle(color:Colors.white, fontSize: 15.sp)),
          )
        ],)
      ],
    );
  }
}
