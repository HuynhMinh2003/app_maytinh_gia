// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get content_welcome_1 =>
      'A fast, accurate, easy-to-use calculator app.';

  @override
  String get content_welcome_2 =>
      'Always ready to help you handle everything from simple to complex calculations anytime, anywhere.';

  @override
  String get con_tinue => 'Continue';

  @override
  String get welcome => 'Welcome to app';

  @override
  String get app_title => 'Calculator';

  @override
  String get enter_pin => 'Enter PIN';

  @override
  String get re_enter_pin => 'Re-enter PIN';

  @override
  String get confirm => 'Confirm';

  @override
  String get msg_pin_empty => 'Please enter the PIN!!!';

  @override
  String get msg_pin_not_match => 'PINs do not match!!!';

  @override
  String get msg_pin_success => 'PIN setup successfully!!!';

  @override
  String get msg_pin_error => 'Error saving PIN.';

  @override
  String msg_error(Object error) {
    return 'Error: $error';
  }

  @override
  String get calculationError => 'Calculation error';

  @override
  String get setting1 => 'Set PIN code';

  @override
  String get setting2 => 'Language Settings';

  @override
  String get setting3 => 'Information';

  @override
  String get setting4 => 'Rate app';

  @override
  String get setting5 => 'Share';

  @override
  String get type => 'Select media type';

  @override
  String get type_1 => 'Image';

  @override
  String get type_2 => 'Video';

  @override
  String get type_3 => 'Favorite file';

  @override
  String get error_1 => 'Failed to hide image';

  @override
  String get delete_1 => 'Restore image';

  @override
  String get delete_12 => 'Are you sure you want to restore this image?';

  @override
  String get delete_13 => 'Cancel';

  @override
  String get delete_14 => 'Image restored successfully!';

  @override
  String get delete_15 => 'Restore';

  @override
  String get title_1 => 'Image';

  @override
  String get title_2 => 'Add image';

  @override
  String get error_2 => 'Failed to hide video';

  @override
  String get delete_2 => 'Restore video';

  @override
  String get delete_22 => 'Are you sure you want to restore this video?';

  @override
  String get delete_23 => 'Cancel';

  @override
  String get delete_24 => 'Video restored successfully!';

  @override
  String get delete_25 => 'Restore';

  @override
  String get title_12 => 'Video';

  @override
  String get title_22 => 'Add video';

  @override
  String get changePinTitle => 'Change PIN';

  @override
  String get oldPinLabel => 'Enter old PIN';

  @override
  String get newPinLabel => 'Enter new PIN';

  @override
  String get confirmPinLabel => 'Confirm new PIN';

  @override
  String get fillAllFieldsError => 'All fields must be filled!';

  @override
  String get pinMismatchError => 'New PIN and confirmation must match.';

  @override
  String get oldPinValidationError => 'Old PIN validation failed.';

  @override
  String get oldPinIncorrectError => 'Old PIN is incorrect.';

  @override
  String get changePinSuccess => 'PIN updated successfully!';

  @override
  String get changePinFailed => 'Failed to change PIN.';

  @override
  String get changePinButton => 'Change PIN';

  @override
  String get favoriteTitle => 'Favorites';

  @override
  String get noFavoritesMessage => 'No favorite images or videos yet.';

  @override
  String get title_app => 'Information';

  @override
  String get title_app1 => 'Application Information';

  @override
  String get info_app => 'This app was developed by student Huỳnh Nhật Minh';

  @override
  String get app_version => 'App Version';

  @override
  String get version => 'Version:';

  @override
  String get build_version => 'Build Code:';

  @override
  String get okay => 'OK';

  @override
  String get title_rate => 'Rate the App';

  @override
  String get content_rate => 'How would you rate this app?';

  @override
  String get rated => 'Submit';

  @override
  String get rate_info => 'Rating successful';

  @override
  String get title_policy => 'Policy';

  @override
  String get content_policy =>
      'The Fake Calculator app is intended for entertainment purposes only. We do not collect, store, or share any personal user data. All calculations and input data are processed solely on your device and are never transmitted externally. By using the app, you agree that it is not an accurate calculation tool for educational or work purposes.';

  @override
  String get language => 'Language';

  @override
  String get content_language => 'Language changed successfully';
}
