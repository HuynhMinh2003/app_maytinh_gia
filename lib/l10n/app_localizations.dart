import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @content_welcome_1.
  ///
  /// In en, this message translates to:
  /// **'A fast, accurate, easy-to-use calculator app.'**
  String get content_welcome_1;

  /// No description provided for @content_welcome_2.
  ///
  /// In en, this message translates to:
  /// **'Always ready to help you handle everything from simple to complex calculations anytime, anywhere.'**
  String get content_welcome_2;

  /// No description provided for @con_tinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get con_tinue;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to app'**
  String get welcome;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get app_title;

  /// No description provided for @enter_pin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enter_pin;

  /// No description provided for @re_enter_pin.
  ///
  /// In en, this message translates to:
  /// **'Re-enter PIN'**
  String get re_enter_pin;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @msg_pin_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the PIN!!!'**
  String get msg_pin_empty;

  /// No description provided for @msg_pin_not_match.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match!!!'**
  String get msg_pin_not_match;

  /// No description provided for @msg_pin_success.
  ///
  /// In en, this message translates to:
  /// **'PIN setup successfully!!!'**
  String get msg_pin_success;

  /// No description provided for @msg_pin_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving PIN.'**
  String get msg_pin_error;

  /// No description provided for @msg_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String msg_error(Object error);

  /// No description provided for @calculationError.
  ///
  /// In en, this message translates to:
  /// **'Calculation error'**
  String get calculationError;

  /// No description provided for @setting1.
  ///
  /// In en, this message translates to:
  /// **'Set PIN code'**
  String get setting1;

  /// No description provided for @setting2.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get setting2;

  /// No description provided for @setting3.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get setting3;

  /// No description provided for @setting4.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get setting4;

  /// No description provided for @setting5.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get setting5;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Select media type'**
  String get type;

  /// No description provided for @type_1.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get type_1;

  /// No description provided for @type_2.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get type_2;

  /// No description provided for @type_3.
  ///
  /// In en, this message translates to:
  /// **'Favorite file'**
  String get type_3;

  /// No description provided for @error_1.
  ///
  /// In en, this message translates to:
  /// **'Failed to hide image'**
  String get error_1;

  /// No description provided for @delete_1.
  ///
  /// In en, this message translates to:
  /// **'Restore image'**
  String get delete_1;

  /// No description provided for @delete_12.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore this image?'**
  String get delete_12;

  /// No description provided for @delete_13.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delete_13;

  /// No description provided for @delete_14.
  ///
  /// In en, this message translates to:
  /// **'Image restored successfully!'**
  String get delete_14;

  /// No description provided for @delete_15.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get delete_15;

  /// No description provided for @title_1.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get title_1;

  /// No description provided for @title_2.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get title_2;

  /// No description provided for @error_2.
  ///
  /// In en, this message translates to:
  /// **'Failed to hide video'**
  String get error_2;

  /// No description provided for @delete_2.
  ///
  /// In en, this message translates to:
  /// **'Restore video'**
  String get delete_2;

  /// No description provided for @delete_22.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore this video?'**
  String get delete_22;

  /// No description provided for @delete_23.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delete_23;

  /// No description provided for @delete_24.
  ///
  /// In en, this message translates to:
  /// **'Video restored successfully!'**
  String get delete_24;

  /// No description provided for @delete_25.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get delete_25;

  /// No description provided for @title_12.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get title_12;

  /// No description provided for @title_22.
  ///
  /// In en, this message translates to:
  /// **'Add video'**
  String get title_22;

  /// No description provided for @changePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinTitle;

  /// No description provided for @oldPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter old PIN'**
  String get oldPinLabel;

  /// No description provided for @newPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get newPinLabel;

  /// No description provided for @confirmPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get confirmPinLabel;

  /// No description provided for @fillAllFieldsError.
  ///
  /// In en, this message translates to:
  /// **'All fields must be filled!'**
  String get fillAllFieldsError;

  /// No description provided for @pinMismatchError.
  ///
  /// In en, this message translates to:
  /// **'New PIN and confirmation must match.'**
  String get pinMismatchError;

  /// No description provided for @oldPinValidationError.
  ///
  /// In en, this message translates to:
  /// **'Old PIN validation failed.'**
  String get oldPinValidationError;

  /// No description provided for @oldPinIncorrectError.
  ///
  /// In en, this message translates to:
  /// **'Old PIN is incorrect.'**
  String get oldPinIncorrectError;

  /// No description provided for @changePinSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN updated successfully!'**
  String get changePinSuccess;

  /// No description provided for @changePinFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change PIN.'**
  String get changePinFailed;

  /// No description provided for @changePinButton.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinButton;

  /// No description provided for @favoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoriteTitle;

  /// No description provided for @noFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'No favorite images or videos yet.'**
  String get noFavoritesMessage;

  /// No description provided for @title_app.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get title_app;

  /// No description provided for @title_app1.
  ///
  /// In en, this message translates to:
  /// **'Application Information'**
  String get title_app1;

  /// No description provided for @info_app.
  ///
  /// In en, this message translates to:
  /// **'This app was developed by student Huỳnh Nhật Minh'**
  String get info_app;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version:'**
  String get version;

  /// No description provided for @build_version.
  ///
  /// In en, this message translates to:
  /// **'Build Code:'**
  String get build_version;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okay;

  /// No description provided for @title_rate.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get title_rate;

  /// No description provided for @content_rate.
  ///
  /// In en, this message translates to:
  /// **'How would you rate this app?'**
  String get content_rate;

  /// No description provided for @rated.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get rated;

  /// No description provided for @rate_info.
  ///
  /// In en, this message translates to:
  /// **'Rating successful'**
  String get rate_info;

  /// No description provided for @title_policy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get title_policy;

  /// No description provided for @content_policy.
  ///
  /// In en, this message translates to:
  /// **'The Fake Calculator app is intended for entertainment purposes only. We do not collect, store, or share any personal user data. All calculations and input data are processed solely on your device and are never transmitted externally. By using the app, you agree that it is not an accurate calculation tool for educational or work purposes.'**
  String get content_policy;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @content_language.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get content_language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
