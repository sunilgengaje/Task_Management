class ValidationHelper {
  // Check if a TextField is empty
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

/*  // Ensure the selected date is not a past date
  static String? validateFutureDate(DateTime? date) {
    if (date != null && date.isBefore(DateTime.now())) {
      return 'Due date cannot be in the past';
    }
    return null;
  }*/
  static String? validateFutureDate(DateTime? date) {
    if (date != null) {
      // Get today's date without time
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);

      if (date.isBefore(startOfDay)) {
        return 'Due date cannot be in the past';
      }
    }
    return null;  // Valid if date is today or in the future
  }


}
