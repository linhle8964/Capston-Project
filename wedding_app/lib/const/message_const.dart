class MessageConst {
  static const String dialogTitle = "Thông báo";
  static const String commonError = "Có lỗi xảy ra";
  static const String commonErrorTitle = "Có lỗi";
  static const String commonLoading = "Đang xử lý dữ liệu";
  static const String commonSuccess = "Thành công";
  static const String invalidEmail = "Email không hợp lệ";
  static const String invalidPassword = "Mật khẩu phải chứa từ 8 đến 20 ký tự và chứa cả số lẫn chữ cái";

  //password
  static const String passwordLengthMin = "Mật khẩu phải có ít nhất 8 ký tự";
  static const String passwordLengthMax = "Mật khẩu không được quá 20 ký tự";
  static const String passwordAtLeastOneCharacter = "Mật khẩu phải chứa chữ cái";
  static const String passwordAtLeastOneNumber = "Mật khẩu phải chứa số";
  // invite email
  static const String userAlreadyInWeddingError =
      "Người dùng này đã có trong đám cưới";
  static const String emailAlreadyInvited = "Email này đã được mời";
  static const String codeNotFound = "Mã không đúng";
  // change password
  static const String oldPasswordError = "Mật khẩu cũ không đúng";
  static const String repeatPasswordError = "Mật khẩu mới nhập lại không đúng";
  static const String changePasswordSuccess = "Thay đổi mật khẩu thành công";
  static const String changePasswordConfirm = "Bạn có muốn thay đổi mật khẩu?";
  static const String passwordDiffError = "Mật khẩu mới phải khác mật khẩu cũ";

  // log in
  static const String emailNotFoundError = "Tài khoản không tồn tại";
  static const String wrongPasswordError = "Sai mật khẩu";
  static const String tooManyRequestError = "Bạn đã đăng nhập quá nhiều lần. Hãy thử lại trong giây lát";
  static const String emailNotVerified = "Bạn chưa xác nhận email";
  static const String loginSuccess = "Đăng nhập thành công";

  // register
  static const String emailAlreadyRegistered = "Email đã tồn tại";
  static const String registerSuccess = "Đăng ký thành công";

  // validate wedding input
  static const String nameTooLong = "Tên không thể quá 20 ký tự";
  static const String nameTooShort = "Tên phải có ít nhất 6 ký tự";
  static const String nameNotContainNumber = "Tên không được chứa số";
  static const String nameNotContainSpecialCharacter = "Tên không được chứa ký tự đặc biệt";
  static const String addressTooLong = "Địa chỉ không thể quá 20 ký tự";
  static const String addressTooShort = "Địa chỉ phải có ít nhất 6 ký tự";
  static const String budgetMin = "Kinh phí phải lớn hơn 100.000đ";
  static const String budgetTripleZero = "Kinh phí phải là bội số của 1000";
  static const String budgetMax = 'Kinh phí không thể lên đến trăm tỷ';

  // crud
  static const String createSuccess = "Tạo thành công";
  static const String updateSuccess = "Chỉnh sửa thành công";
  static const String deleteSuccess = "Xoá thành công";
}
