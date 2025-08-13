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
  /// **'The app supports quick, accurate, and easy calculations.'**
  String get content_welcome_1;

  /// No description provided for @content_welcome_2.
  ///
  /// In en, this message translates to:
  /// **'Always ready to help you handle calculations from simple to complex anytime, anywhere.'**
  String get content_welcome_2;

  /// No description provided for @content_welcome_3.
  ///
  /// In en, this message translates to:
  /// **'An intuitive interface helps you operate quickly without complicated instructions.'**
  String get content_welcome_3;

  /// No description provided for @content_welcome_4.
  ///
  /// In en, this message translates to:
  /// **'Designed to deliver the smoothest and most efficient experience for all users.'**
  String get content_welcome_4;

  /// No description provided for @content_welcome_5.
  ///
  /// In en, this message translates to:
  /// **'Easily customizable to fit your needs and optimize your daily work.'**
  String get content_welcome_5;

  /// No description provided for @content_welcome_6.
  ///
  /// In en, this message translates to:
  /// **'Absolute information security to give you peace of mind anytime, anywhere.'**
  String get content_welcome_6;

  /// No description provided for @con_tinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get con_tinue;

  /// No description provided for @con_tinue1.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get con_tinue1;

  /// No description provided for @welcome_1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the handheld calculator app'**
  String get welcome_1;

  /// No description provided for @welcome_2.
  ///
  /// In en, this message translates to:
  /// **'Discover amazing features'**
  String get welcome_2;

  /// No description provided for @welcome_3.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us'**
  String get welcome_3;

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

  /// No description provided for @input_checkpin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get input_checkpin;

  /// No description provided for @checkpin.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkpin;

  /// No description provided for @checkpin_false.
  ///
  /// In en, this message translates to:
  /// **'Valid PIN'**
  String get checkpin_false;

  /// No description provided for @checkpin_okay.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get checkpin_okay;

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

  /// No description provided for @type_4.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get type_4;

  /// No description provided for @error_1.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete image'**
  String get error_1;

  /// No description provided for @delete_1.
  ///
  /// In en, this message translates to:
  /// **'Delete image'**
  String get delete_1;

  /// No description provided for @delete_12.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image?'**
  String get delete_12;

  /// No description provided for @delete_13.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delete_13;

  /// No description provided for @delete_14.
  ///
  /// In en, this message translates to:
  /// **'Image deleted successfully!'**
  String get delete_14;

  /// No description provided for @delete_15.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_15;

  /// No description provided for @title_1.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get title_1;

  /// No description provided for @title_2.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get title_2;

  /// No description provided for @no_images.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get no_images;

  /// No description provided for @no_videos.
  ///
  /// In en, this message translates to:
  /// **'No videos available'**
  String get no_videos;

  /// No description provided for @error_2.
  ///
  /// In en, this message translates to:
  /// **'Failed to hide video'**
  String get error_2;

  /// No description provided for @delete_2.
  ///
  /// In en, this message translates to:
  /// **'Delete video'**
  String get delete_2;

  /// No description provided for @delete_22.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this video?'**
  String get delete_22;

  /// No description provided for @delete_23.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delete_23;

  /// No description provided for @delete_24.
  ///
  /// In en, this message translates to:
  /// **'Video deleted successfully!'**
  String get delete_24;

  /// No description provided for @delete_25.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_25;

  /// No description provided for @title_12.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get title_12;

  /// No description provided for @title_22.
  ///
  /// In en, this message translates to:
  /// **'Add video'**
  String get title_22;

  /// No description provided for @moveToFolder.
  ///
  /// In en, this message translates to:
  /// **'Move to folder'**
  String get moveToFolder;

  /// No description provided for @chooseFolderToMove.
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get chooseFolderToMove;

  /// No description provided for @noFoldersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No folders available.'**
  String get noFoldersAvailable;

  /// No description provided for @cancel1.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel1;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @moveSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Move successful'**
  String get moveSuccessful;

  /// No description provided for @moveFailed.
  ///
  /// In en, this message translates to:
  /// **'Move failed'**
  String get moveFailed;

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
  /// **'Rate App'**
  String get title_rate;

  /// No description provided for @content_rate.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to give your rating.'**
  String get content_rate;

  /// No description provided for @rated.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get rated;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

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

  /// No description provided for @title_folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get title_folder;

  /// No description provided for @add_folder.
  ///
  /// In en, this message translates to:
  /// **'Create new folder'**
  String get add_folder;

  /// No description provided for @dien_folder.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get dien_folder;

  /// No description provided for @no_folder.
  ///
  /// In en, this message translates to:
  /// **'No folders available'**
  String get no_folder;

  /// No description provided for @cancel_folder.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_folder;

  /// No description provided for @okay_folder.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get okay_folder;

  /// No description provided for @folder_name_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter a folder name'**
  String get folder_name_required;

  /// No description provided for @d.
  ///
  /// In en, this message translates to:
  /// **'Folder created successfully'**
  String get d;

  /// No description provided for @s.
  ///
  /// In en, this message translates to:
  /// **'Folder creation failed'**
  String get s;

  /// No description provided for @restore_file_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete file'**
  String get restore_file_failed;

  /// No description provided for @restore_file_success.
  ///
  /// In en, this message translates to:
  /// **'File deleted successfully'**
  String get restore_file_success;

  /// No description provided for @delete_file_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete file'**
  String get delete_file_failed;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: '**
  String get error_occurred;

  /// No description provided for @folder_empty.
  ///
  /// In en, this message translates to:
  /// **'Folder is empty'**
  String get folder_empty;

  /// No description provided for @cannot_display_image.
  ///
  /// In en, this message translates to:
  /// **'Cannot display image'**
  String get cannot_display_image;

  /// No description provided for @not_supported.
  ///
  /// In en, this message translates to:
  /// **'Not supported'**
  String get not_supported;

  /// No description provided for @file_empty.
  ///
  /// In en, this message translates to:
  /// **'File is empty'**
  String get file_empty;

  /// No description provided for @restore_file.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get restore_file;

  /// No description provided for @confirm_restore_file_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this file?'**
  String get confirm_restore_file_message;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @rename_folder.
  ///
  /// In en, this message translates to:
  /// **'Rename Folder'**
  String get rename_folder;

  /// No description provided for @delete_folder_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get delete_folder_title;

  /// No description provided for @delete_folder_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this folder?'**
  String get delete_folder_confirm;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Folder deleted successfully.'**
  String get delete_success;

  /// No description provided for @delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete folder.'**
  String get delete_failed;

  /// No description provided for @rename_folder_title.
  ///
  /// In en, this message translates to:
  /// **'Rename Folder'**
  String get rename_folder_title;

  /// No description provided for @enter_new_folder_name.
  ///
  /// In en, this message translates to:
  /// **'Enter new folder name'**
  String get enter_new_folder_name;

  /// No description provided for @rename_success.
  ///
  /// In en, this message translates to:
  /// **'Folder renamed successfully.'**
  String get rename_success;

  /// No description provided for @rename_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to rename folder.'**
  String get rename_failed;

  /// No description provided for @copy_to_gallery_title.
  ///
  /// In en, this message translates to:
  /// **'Save Image to Gallery'**
  String get copy_to_gallery_title;

  /// No description provided for @copy_to_gallery_content.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save this image to your device\'s gallery?'**
  String get copy_to_gallery_content;

  /// No description provided for @copy_to_gallery_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get copy_to_gallery_cancel;

  /// No description provided for @copy_to_gallery_confirm.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get copy_to_gallery_confirm;

  /// No description provided for @copy_to_gallery_success.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery successfully'**
  String get copy_to_gallery_success;

  /// No description provided for @copy_to_gallery_fail.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image to gallery'**
  String get copy_to_gallery_fail;

  /// No description provided for @deleteVideoSuccess.
  ///
  /// In en, this message translates to:
  /// **'Video deleted successfully'**
  String get deleteVideoSuccess;

  /// No description provided for @deleteVideoFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete video'**
  String get deleteVideoFail;

  /// No description provided for @copyVideoToGallerySuccess.
  ///
  /// In en, this message translates to:
  /// **'Video saved to gallery successfully'**
  String get copyVideoToGallerySuccess;

  /// No description provided for @copyVideoToGalleryFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to save video to gallery'**
  String get copyVideoToGalleryFail;

  /// No description provided for @copyVideoToGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Save video to gallery'**
  String get copyVideoToGalleryTitle;

  /// No description provided for @copyVideoToGalleryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save this video to your device\'s gallery?'**
  String get copyVideoToGalleryConfirm;

  /// No description provided for @video_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get video_cancel;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get copy;

  /// No description provided for @restore_folder_title.
  ///
  /// In en, this message translates to:
  /// **'Download files to library'**
  String get restore_folder_title;

  /// No description provided for @restore_folder_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to download all files in this folder to the library?'**
  String get restore_folder_confirm;

  /// No description provided for @cancel2.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel2;

  /// No description provided for @restore_success.
  ///
  /// In en, this message translates to:
  /// **'Files downloaded successfully'**
  String get restore_success;

  /// No description provided for @restore_failed.
  ///
  /// In en, this message translates to:
  /// **'File download failed'**
  String get restore_failed;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get restore;

  /// No description provided for @delete_file_title.
  ///
  /// In en, this message translates to:
  /// **'Delete File'**
  String get delete_file_title;

  /// No description provided for @delete_file_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this file from the app?'**
  String get delete_file_confirm;

  /// No description provided for @delete_file_success.
  ///
  /// In en, this message translates to:
  /// **'File deleted successfully'**
  String get delete_file_success;

  /// No description provided for @delete_file_failed1.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete file'**
  String get delete_file_failed1;

  /// No description provided for @restore_file_title.
  ///
  /// In en, this message translates to:
  /// **'Save File to Library'**
  String get restore_file_title;

  /// No description provided for @restore_file_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save this file?'**
  String get restore_file_confirm;

  /// No description provided for @restore_file_success1.
  ///
  /// In en, this message translates to:
  /// **'File saved successfully'**
  String get restore_file_success1;

  /// No description provided for @restore_file_failed1.
  ///
  /// In en, this message translates to:
  /// **'Failed to save file'**
  String get restore_file_failed1;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @restore3.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get restore3;

  /// No description provided for @cancel3.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel3;
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
