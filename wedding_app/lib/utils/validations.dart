class Validation {
  static bool isStringValid(String text, int length) {
    return text != null && text.length >= length;
  }

  static bool isNameValid(String name) {
    return name != null && RegExp(r'^[a-zA-Z\s]{6,20}$').hasMatch(name);
  }

  static bool isAddressValid(String address) {
    return address != null && address.length >= 6 && address.length <= 40;
  }

  static bool isEmailValid(String email) {
    return email != null &&
        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return password != null &&
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$').hasMatch(password);
  }

  static bool isBudgetValid(String budget) {
    if (budget != null) {
      if (budget.isEmpty) return false;
      double budgetDouble = double.parse(budget.replaceAll(",", ""));
      return budgetDouble > 100000 &&
          budgetDouble % 1000 == 0 &&
          budgetDouble <= 10000000000;
    }
    return false;
  }
}
