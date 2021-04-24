class Validation {
  static bool isStringValid(String text, int length) {
    return text != null && text.length >= length;
  }

  static bool isNameValid(String name) {
    return name != null && RegExp(r'^[a-zA-Z\s]{1,20}$').hasMatch(name);
  }

  static bool isAddressValid(String address) {
    return address != null && RegExp(r'^[1-9a-zA-Z\s]{2,20}$').hasMatch(address);
  }

  static bool isEmailValid(String email) {
    return email != null && RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return password != null && RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,20}$')
        .hasMatch(password);
  }

  static bool isBudgetValid(String budget) {
    if (budget != null){
      if(budget.isEmpty) return false;
      double budgetDouble = double.parse(budget.replaceAll(",", ""));
      return budgetDouble > 100000 && budgetDouble % 1000 == 0;
    }
    return false;
  }
}
