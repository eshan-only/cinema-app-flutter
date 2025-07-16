import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date); // Customize the date format as needed
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Format for Pakistani phone number
    // Assuming a 10-digit Pakistani phone number without country code.
    // Example: 3001234567
    if (phoneNumber.length == 11 && phoneNumber.startsWith('3')) {
      return '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    // If it's not a valid Pakistani phone number, return it as is
    return phoneNumber;
  }

  // Not fully tested.
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if it is a valid Pakistani number and format accordingly
    if (digitsOnly.length == 12 && digitsOnly.startsWith('92')) {
      digitsOnly = digitsOnly.substring(2);  // Remove the country code (92)
    }

    // Format Pakistani phone number like: (0300) 123 4567
    if (digitsOnly.length == 10 && digitsOnly.startsWith('3')) {
      final formattedNumber = StringBuffer();
      formattedNumber.write('(${digitsOnly.substring(0, 4)}) ');
      formattedNumber.write('${digitsOnly.substring(4, 7)} ');
      formattedNumber.write(digitsOnly.substring(7));
      return formattedNumber.toString();
    }

    // If it’s not a valid number, return the number as is
    return phoneNumber;
  }
}
