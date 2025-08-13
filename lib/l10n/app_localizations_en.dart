// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get content_welcome_1 =>
      'The app supports quick, accurate, and easy calculations.';

  @override
  String get content_welcome_2 =>
      'Always ready to help you handle calculations from simple to complex anytime, anywhere.';

  @override
  String get content_welcome_3 =>
      'An intuitive interface helps you operate quickly without complicated instructions.';

  @override
  String get content_welcome_4 =>
      'Designed to deliver the smoothest and most efficient experience for all users.';

  @override
  String get content_welcome_5 =>
      'Easily customizable to fit your needs and optimize your daily work.';

  @override
  String get content_welcome_6 =>
      'Absolute information security to give you peace of mind anytime, anywhere.';

  @override
  String get con_tinue => 'Continue';

  @override
  String get con_tinue1 => 'Next';

  @override
  String get welcome_1 => 'Welcome to the handheld calculator app';

  @override
  String get welcome_2 => 'Discover amazing features';

  @override
  String get welcome_3 => 'Start your journey with us';

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
  String get input_checkpin => 'Enter PIN';

  @override
  String get checkpin => 'Check';

  @override
  String get checkpin_false => 'Valid PIN';

  @override
  String get checkpin_okay => 'Incorrect PIN';

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
  String get type_4 => 'Folder';

  @override
  String get error_1 => 'Failed to delete image';

  @override
  String get delete_1 => 'Delete image';

  @override
  String get delete_12 => 'Are you sure you want to delete this image?';

  @override
  String get delete_13 => 'Cancel';

  @override
  String get delete_14 => 'Image deleted successfully!';

  @override
  String get delete_15 => 'Delete';

  @override
  String get title_1 => 'Images';

  @override
  String get title_2 => 'Add image';

  @override
  String get no_images => 'No images available';

  @override
  String get no_videos => 'No videos available';

  @override
  String get error_2 => 'Failed to hide video';

  @override
  String get delete_2 => 'Delete video';

  @override
  String get delete_22 => 'Are you sure you want to delete this video?';

  @override
  String get delete_23 => 'Cancel';

  @override
  String get delete_24 => 'Video deleted successfully!';

  @override
  String get delete_25 => 'Delete';

  @override
  String get title_12 => 'Videos';

  @override
  String get title_22 => 'Add video';

  @override
  String get moveToFolder => 'Move to folder';

  @override
  String get chooseFolderToMove => 'Choose folder';

  @override
  String get noFoldersAvailable => 'No folders available.';

  @override
  String get cancel1 => 'Cancel';

  @override
  String get move => 'Move';

  @override
  String get moveSuccessful => 'Move successful';

  @override
  String get moveFailed => 'Move failed';

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
  String get title_rate => 'Rate App';

  @override
  String get content_rate => 'Tap a star to give your rating.';

  @override
  String get rated => 'Submit';

  @override
  String get cancel => 'Cancel';

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

  @override
  String get title_folder => 'Folder';

  @override
  String get add_folder => 'Create new folder';

  @override
  String get dien_folder => 'Enter folder name';

  @override
  String get no_folder => 'No folders available';

  @override
  String get cancel_folder => 'Cancel';

  @override
  String get okay_folder => 'Create';

  @override
  String get folder_name_required => 'Please enter a folder name';

  @override
  String get d => 'Folder created successfully';

  @override
  String get s => 'Folder creation failed';

  @override
  String get restore_file_failed => 'Failed to delete file';

  @override
  String get restore_file_success => 'File deleted successfully';

  @override
  String get delete_file_failed => 'Failed to delete file';

  @override
  String get error_occurred => 'An error occurred: ';

  @override
  String get folder_empty => 'Folder is empty';

  @override
  String get cannot_display_image => 'Cannot display image';

  @override
  String get not_supported => 'Not supported';

  @override
  String get file_empty => 'File is empty';

  @override
  String get restore_file => 'Delete file';

  @override
  String get confirm_restore_file_message => 'Do you want to delete this file?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get rename_folder => 'Rename Folder';

  @override
  String get delete_folder_title => 'Delete Folder';

  @override
  String get delete_folder_confirm =>
      'Are you sure you want to delete this folder?';

  @override
  String get delete_success => 'Folder deleted successfully.';

  @override
  String get delete_failed => 'Failed to delete folder.';

  @override
  String get rename_folder_title => 'Rename Folder';

  @override
  String get enter_new_folder_name => 'Enter new folder name';

  @override
  String get rename_success => 'Folder renamed successfully.';

  @override
  String get rename_failed => 'Failed to rename folder.';

  @override
  String get copy_to_gallery_title => 'Save Image to Gallery';

  @override
  String get copy_to_gallery_content =>
      'Do you want to save this image to your device\'s gallery?';

  @override
  String get copy_to_gallery_cancel => 'Cancel';

  @override
  String get copy_to_gallery_confirm => 'Save';

  @override
  String get copy_to_gallery_success => 'Image saved to gallery successfully';

  @override
  String get copy_to_gallery_fail => 'Failed to save image to gallery';

  @override
  String get deleteVideoSuccess => 'Video deleted successfully';

  @override
  String get deleteVideoFail => 'Failed to delete video';

  @override
  String get copyVideoToGallerySuccess => 'Video saved to gallery successfully';

  @override
  String get copyVideoToGalleryFail => 'Failed to save video to gallery';

  @override
  String get copyVideoToGalleryTitle => 'Save video to gallery';

  @override
  String get copyVideoToGalleryConfirm =>
      'Do you want to save this video to your device\'s gallery?';

  @override
  String get video_cancel => 'Cancel';

  @override
  String get copy => 'Save';

  @override
  String get restore_folder_title => 'Download files to library';

  @override
  String get restore_folder_confirm =>
      'Are you sure you want to download all files in this folder to the library?';

  @override
  String get cancel2 => 'Cancel';

  @override
  String get restore_success => 'Files downloaded successfully';

  @override
  String get restore_failed => 'File download failed';

  @override
  String get restore => 'Download';

  @override
  String get delete_file_title => 'Delete File';

  @override
  String get delete_file_confirm =>
      'Are you sure you want to delete this file from the app?';

  @override
  String get delete_file_success => 'File deleted successfully';

  @override
  String get delete_file_failed1 => 'Failed to delete file';

  @override
  String get restore_file_title => 'Save File to Library';

  @override
  String get restore_file_confirm => 'Are you sure you want to save this file?';

  @override
  String get restore_file_success1 => 'File saved successfully';

  @override
  String get restore_file_failed1 => 'Failed to save file';

  @override
  String get delete => 'Delete';

  @override
  String get restore3 => 'Save';

  @override
  String get cancel3 => 'Cancel';
}
