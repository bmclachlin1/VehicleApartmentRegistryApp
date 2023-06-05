class FormHelpers {
  static List<int> generateYearsForDropdown() {
    int currentYear = DateTime.now().year;
    return List<int>.generate(currentYear - 1970 + 1, (index) => 1970 + index)
        .reversed
        .toList();
  }

  static bool stringFieldValidatorCondition(value) {
    return value == null || value.length < 2;
  }

  static String? validateDate(DateTime? dt) {
    if (dt == null) {
      return "Please choose a date";
    }
    return null;
  }
}