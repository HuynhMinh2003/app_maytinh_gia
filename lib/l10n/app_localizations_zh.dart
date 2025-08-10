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
  String get content_welcome_2 => '随时随地帮助您处理从简单到复杂的各种计算。';

  @override
  String get con_tinue => '继续';

  @override
  String get welcome => '欢迎使用本应用';

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
  String get error_1 => '隐藏图片失败';

  @override
  String get delete_1 => '恢复图片';

  @override
  String get delete_12 => '您确定要恢复这张图片吗？';

  @override
  String get delete_13 => '取消';

  @override
  String get delete_14 => '图片恢复成功！';

  @override
  String get delete_15 => '恢复';

  @override
  String get title_1 => '图片';

  @override
  String get title_2 => '添加图片';

  @override
  String get error_2 => '隐藏视频失败';

  @override
  String get delete_2 => '恢复视频';

  @override
  String get delete_22 => '您确定要恢复这个视频吗？';

  @override
  String get delete_23 => '取消';

  @override
  String get delete_24 => '视频恢复成功！';

  @override
  String get delete_25 => '恢复';

  @override
  String get title_12 => '视频';

  @override
  String get title_22 => '添加视频';

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
  String get content_rate => '您如何评价此应用？';

  @override
  String get rated => '提交';

  @override
  String get rate_info => '评价成功';

  @override
  String get title_policy => '政策';

  @override
  String get content_policy =>
      '假计算器应用仅供娱乐用途。我们不会收集、存储或分享任何用户的个人数据。所有计算和输入数据仅在您的设备上处理，从不会发送到外部。使用本应用即表示您同意它不是用于学习或工作目的的精确计算工具。';

  @override
  String get language => '语言';

  @override
  String get content_language => '语言更改成功';
}
