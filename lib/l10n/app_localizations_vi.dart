// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get content_welcome_1 =>
      'Ứng dụng hỗ trợ tính toán nhanh chóng, chính xác và dễ sử dụng.';

  @override
  String get content_welcome_2 =>
      'Luôn sẵn sàng giúp bạn xử lý các phép toán từ đơn giản đến phức tạp mọi lúc, mọi nơi.';

  @override
  String get con_tinue => 'Tiếp tục';

  @override
  String get welcome => 'Chào mừng đến ứng dụng';

  @override
  String get app_title => 'Máy tính';

  @override
  String get enter_pin => 'Nhập mã pin';

  @override
  String get re_enter_pin => 'Nhập lại mã pin';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get msg_pin_empty => 'Vui lòng nhập mã pin !!!';

  @override
  String get msg_pin_not_match => 'Mã pin không khớp !!!';

  @override
  String get msg_pin_success => 'Thiết lập mã pin thành công !!!';

  @override
  String get msg_pin_error => 'Lỗi khi lưu mã pin.';

  @override
  String msg_error(Object error) {
    return 'Lỗi: $error';
  }

  @override
  String get calculationError => 'Lỗi tính toán';

  @override
  String get setting1 => 'Cài đặt mã pin';

  @override
  String get setting2 => 'Cài đặt ngôn ngữ';

  @override
  String get setting3 => 'Thông tin';

  @override
  String get setting4 => 'Đánh giá';

  @override
  String get setting5 => 'Chia sẻ';

  @override
  String get type => 'Chọn loại phương tiện';

  @override
  String get type_1 => 'Ảnh';

  @override
  String get type_2 => 'Video';

  @override
  String get type_3 => 'File yêu thích';

  @override
  String get error_1 => 'Ẩn ảnh thất bại';

  @override
  String get delete_1 => 'Khôi phục ảnh';

  @override
  String get delete_12 => 'Bạn có chắc chắn muốn khôi phục ảnh này không?';

  @override
  String get delete_13 => 'Hủy';

  @override
  String get delete_14 => 'Đã khôi phục ảnh thành công!';

  @override
  String get delete_15 => 'Khôi phục';

  @override
  String get title_1 => 'Ảnh';

  @override
  String get title_2 => 'Thêm ảnh';

  @override
  String get error_2 => 'Ẩn video thất bại';

  @override
  String get delete_2 => 'Khôi phục video';

  @override
  String get delete_22 => 'Bạn có chắc chắn muốn khôi phục video này không?';

  @override
  String get delete_23 => 'Hủy';

  @override
  String get delete_24 => 'Đã khôi phục video thành công!';

  @override
  String get delete_25 => 'Khôi phục';

  @override
  String get title_12 => 'Video';

  @override
  String get title_22 => 'Thêm video';

  @override
  String get changePinTitle => 'Đổi mã PIN';

  @override
  String get oldPinLabel => 'Nhập mã PIN cũ';

  @override
  String get newPinLabel => 'Nhập mã PIN mới';

  @override
  String get confirmPinLabel => 'Xác nhận mã PIN mới';

  @override
  String get fillAllFieldsError => 'Phải điền đủ thông tin mã !!!';

  @override
  String get pinMismatchError => 'Mã PIN mới và xác nhận phải giống nhau.';

  @override
  String get oldPinValidationError => 'Lỗi xác thực mã PIN cũ.';

  @override
  String get oldPinIncorrectError => 'Mã PIN cũ không đúng.';

  @override
  String get changePinSuccess => 'Đã cập nhật mã PIN thành công!';

  @override
  String get changePinFailed => 'Đổi mã PIN thất bại.';

  @override
  String get changePinButton => 'Đổi mã PIN';

  @override
  String get favoriteTitle => 'Yêu thích';

  @override
  String get noFavoritesMessage => 'Chưa có ảnh hoặc video yêu thích nào.';

  @override
  String get title_app => 'Thông tin';

  @override
  String get title_app1 => 'Thông tin ứng dụng';

  @override
  String get info_app => 'App được xây dựng bởi sinh viên Huỳnh Nhật Minh';

  @override
  String get app_version => 'Phiên bản ứng dụng';

  @override
  String get version => 'Phiên bản:';

  @override
  String get build_version => 'Mã build:';

  @override
  String get okay => 'Đồng ý';

  @override
  String get title_rate => 'Đánh giá ứng dụng';

  @override
  String get content_rate => 'Bạn đánh giá ứng dụng như thế nào?';

  @override
  String get rated => 'Gửi';

  @override
  String get rate_info => 'Đánh giá thành công';

  @override
  String get title_policy => 'Chính sách';

  @override
  String get content_policy =>
      'Ứng dụng Máy Tính Giả chỉ nhằm mục đích giải trí. Chúng tôi không thu thập, lưu trữ hay chia sẻ bất kỳ dữ liệu cá nhân nào của người dùng. Mọi phép tính và dữ liệu nhập vào chỉ được xử lý trên thiết bị của bạn và sẽ không được gửi ra ngoài. Bằng cách sử dụng ứng dụng, bạn đồng ý rằng đây không phải là công cụ tính toán chính xác cho mục đích học tập hay công việc.';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get content_language => 'Đổi ngôn ngữ thành công';
}
