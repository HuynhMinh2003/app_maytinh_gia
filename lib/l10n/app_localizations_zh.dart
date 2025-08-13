// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get content_welcome_1 => '该应用支持快速、准确且易于使用的计算。';

  @override
  String get content_welcome_2 => '随时随地帮助您处理从简单到复杂的计算。';

  @override
  String get content_welcome_3 => '直观的界面帮助您快速操作，无需复杂的说明。';

  @override
  String get content_welcome_4 => '旨在为所有用户提供最流畅和高效的体验。';

  @override
  String get content_welcome_5 => '轻松根据您的需求定制，优化您的日常工作。';

  @override
  String get content_welcome_6 => '绝对的信息安全，让您随时随地安心使用。';

  @override
  String get con_tinue => '继续';

  @override
  String get con_tinue1 => '下一步';

  @override
  String get welcome_1 => '欢迎使用掌上计算器应用';

  @override
  String get welcome_2 => '探索精彩功能';

  @override
  String get welcome_3 => '与我们一起开始旅程';

  @override
  String get app_title => '计算器';

  @override
  String get enter_pin => '请输入PIN码';

  @override
  String get re_enter_pin => '请再次输入PIN码';

  @override
  String get confirm => '确认';

  @override
  String get msg_pin_empty => '请输入PIN码！！！';

  @override
  String get msg_pin_not_match => 'PIN码不匹配！！！';

  @override
  String get msg_pin_success => 'PIN码设置成功！！！';

  @override
  String get msg_pin_error => '保存PIN码时出错。';

  @override
  String msg_error(Object error) {
    return '错误：$error';
  }

  @override
  String get calculationError => '计算错误';

  @override
  String get input_checkpin => '输入PIN码';

  @override
  String get checkpin => '检查';

  @override
  String get checkpin_false => 'PIN码有效';

  @override
  String get checkpin_okay => 'PIN码不正确';

  @override
  String get setting1 => '设置PIN码';

  @override
  String get setting2 => '语言设置';

  @override
  String get setting3 => '信息';

  @override
  String get setting4 => '评分';

  @override
  String get setting5 => '分享';

  @override
  String get type => '选择媒体类型';

  @override
  String get type_1 => '图片';

  @override
  String get type_2 => '视频';

  @override
  String get type_3 => '收藏文件';

  @override
  String get type_4 => '文件夹';

  @override
  String get error_1 => '删除图片失败';

  @override
  String get delete_1 => '删除图片';

  @override
  String get delete_12 => '您确定要删除这张图片吗？';

  @override
  String get delete_13 => '取消';

  @override
  String get delete_14 => '图片删除成功！';

  @override
  String get delete_15 => '删除';

  @override
  String get title_1 => '图片';

  @override
  String get title_2 => '添加图片';

  @override
  String get no_images => '暂无图片';

  @override
  String get no_videos => '暂无视频';

  @override
  String get error_2 => '隐藏视频失败';

  @override
  String get delete_2 => '删除视频';

  @override
  String get delete_22 => '您确定要删除这段视频吗？';

  @override
  String get delete_23 => '取消';

  @override
  String get delete_24 => '视频删除成功！';

  @override
  String get delete_25 => '删除';

  @override
  String get title_12 => '视频';

  @override
  String get title_22 => '添加视频';

  @override
  String get moveToFolder => '移动到文件夹';

  @override
  String get chooseFolderToMove => '选择文件夹';

  @override
  String get noFoldersAvailable => '没有可用的文件夹。';

  @override
  String get cancel1 => '取消';

  @override
  String get move => '移动';

  @override
  String get moveSuccessful => '移动成功';

  @override
  String get moveFailed => '移动失败';

  @override
  String get changePinTitle => '更改PIN码';

  @override
  String get oldPinLabel => '请输入旧PIN码';

  @override
  String get newPinLabel => '请输入新PIN码';

  @override
  String get confirmPinLabel => '确认新PIN码';

  @override
  String get fillAllFieldsError => '所有PIN信息必须填写！！！';

  @override
  String get pinMismatchError => '新PIN码和确认PIN码必须一致。';

  @override
  String get oldPinValidationError => '旧PIN码验证错误。';

  @override
  String get oldPinIncorrectError => '旧PIN码不正确。';

  @override
  String get changePinSuccess => 'PIN码更新成功！';

  @override
  String get changePinFailed => '更改PIN码失败。';

  @override
  String get changePinButton => '更改PIN码';

  @override
  String get favoriteTitle => '收藏';

  @override
  String get noFavoritesMessage => '目前没有收藏的图片或视频。';

  @override
  String get title_app => '信息';

  @override
  String get title_app1 => '应用信息';

  @override
  String get info_app => '本应用由学生胡英日明开发';

  @override
  String get app_version => '应用版本';

  @override
  String get version => '版本：';

  @override
  String get build_version => '构建代码：';

  @override
  String get okay => '确定';

  @override
  String get title_rate => '评价应用';

  @override
  String get content_rate => '点击星星进行评分。';

  @override
  String get rated => '提交';

  @override
  String get cancel => '取消';

  @override
  String get rate_info => '评分成功';

  @override
  String get title_policy => '政策';

  @override
  String get content_policy =>
      '假计算器应用仅供娱乐用途。我们不会收集、存储或分享任何用户的个人数据。所有计算和输入数据仅在您的设备上处理，从不会发送到外部。使用本应用即表示您同意它不是用于学习或工作目的的精确计算工具。';

  @override
  String get language => '语言';

  @override
  String get content_language => '语言更改成功';

  @override
  String get title_folder => '文件夹';

  @override
  String get add_folder => '创建新文件夹';

  @override
  String get dien_folder => '输入文件夹名称';

  @override
  String get no_folder => '暂无文件夹';

  @override
  String get cancel_folder => '取消';

  @override
  String get okay_folder => '创建';

  @override
  String get folder_name_required => '请输入文件夹名称';

  @override
  String get d => '文件夹创建成功';

  @override
  String get s => '文件夹创建失败';

  @override
  String get restore_file_failed => '删除文件失败';

  @override
  String get restore_file_success => '文件删除成功';

  @override
  String get delete_file_failed => '删除文件失败';

  @override
  String get error_occurred => '发生错误：';

  @override
  String get folder_empty => '文件夹为空';

  @override
  String get cannot_display_image => '无法显示图片';

  @override
  String get not_supported => '不支持';

  @override
  String get file_empty => '文件为空';

  @override
  String get restore_file => '删除文件';

  @override
  String get confirm_restore_file_message => '您想删除此文件吗？';

  @override
  String get no => '否';

  @override
  String get yes => '是';

  @override
  String get rename_folder => '重命名文件夹';

  @override
  String get delete_folder_title => '删除文件夹';

  @override
  String get delete_folder_confirm => '您确定要删除此文件夹吗？';

  @override
  String get delete_success => '文件夹删除成功。';

  @override
  String get delete_failed => '删除文件夹失败。';

  @override
  String get rename_folder_title => '重命名文件夹';

  @override
  String get enter_new_folder_name => '请输入新的文件夹名称';

  @override
  String get rename_success => '文件夹重命名成功。';

  @override
  String get rename_failed => '文件夹重命名失败。';

  @override
  String get copy_to_gallery_title => '保存图片到相册';

  @override
  String get copy_to_gallery_content => '您想将此图片保存到设备的相册吗？';

  @override
  String get copy_to_gallery_cancel => '取消';

  @override
  String get copy_to_gallery_confirm => '保存';

  @override
  String get copy_to_gallery_success => '图片已成功保存到相册';

  @override
  String get copy_to_gallery_fail => '保存图片到相册失败';

  @override
  String get deleteVideoSuccess => '视频删除成功';

  @override
  String get deleteVideoFail => '删除视频失败';

  @override
  String get copyVideoToGallerySuccess => '视频已成功保存到相册';

  @override
  String get copyVideoToGalleryFail => '保存视频到相册失败';

  @override
  String get copyVideoToGalleryTitle => '保存视频到相册';

  @override
  String get copyVideoToGalleryConfirm => '您想将此视频保存到设备相册吗？';

  @override
  String get video_cancel => '取消';

  @override
  String get copy => '保存';

  @override
  String get restore_folder_title => '将文件下载到图库';

  @override
  String get restore_folder_confirm => '您确定要将此文件夹中的所有文件下载到图库吗？';

  @override
  String get cancel2 => '取消';

  @override
  String get restore_success => '文件下载成功';

  @override
  String get restore_failed => '文件下载失败';

  @override
  String get restore => '下载';

  @override
  String get delete_file_title => '删除文件';

  @override
  String get delete_file_confirm => '您确定要从应用中删除此文件吗？';

  @override
  String get delete_file_success => '文件删除成功';

  @override
  String get delete_file_failed1 => '删除文件失败';

  @override
  String get restore_file_title => '将文件保存到图库';

  @override
  String get restore_file_confirm => '您确定要保存此文件吗？';

  @override
  String get restore_file_success1 => '文件保存成功';

  @override
  String get restore_file_failed1 => '保存文件失败';

  @override
  String get delete => '删除';

  @override
  String get restore3 => '保存';

  @override
  String get cancel3 => '取消';
}
