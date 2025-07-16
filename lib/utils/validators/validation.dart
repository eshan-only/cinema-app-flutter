
class MyValidator {

  // Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value){
    if(value==null || value.isEmpty){
      return '$fieldName is required.';
    }
    return null;
  }
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required.';
  }

  // Regular expression for Pakistani phone numbers
  final phoneRegExp = RegExp(r'^(?:\+92|92|0)?3\d{9}$');

  if (!phoneRegExp.hasMatch(value)) {
    return 'Invalid Pakistani phone number. Must be in the format +923XXXXXXXXX or 03XXXXXXXXX.';
  }

  return null;
}


}
