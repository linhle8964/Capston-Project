class Validation {
  static bool isStringValid(String text, int length) {
    return text != null && text.length >= length;
  }

  static bool isNameValid(String name) {
    return RegExp(r'^[a-zA-Z\s]{6,20}$').hasMatch(name);
  }

  static bool isAddressValid(String address) {
    return RegExp(r'^[a-zA-Z0-9!@#<>?":_`~;[\]\\|=+)(*&^%\s-]{6,20}$').hasMatch(address);
  }

  static bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$')
        .hasMatch(password);
  }

  static bool isBudgetValid(String budget) {
    double budgetDouble = double.parse(budget.replaceAll(",", ""));
    return budgetDouble > 100000 && budgetDouble % 1000 == 0 && budgetDouble <= 10000000000;
  }

  static bool containNumber(String input){

  }
}
