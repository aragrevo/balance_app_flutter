import 'package:intl/intl.dart';

String toCurrency(dynamic value) {
  return NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0)
      .format(value);
}

extension StringUtil on String {
  String get toCapitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DateUtil on DateTime {
  String get nameMonth {
    return DateFormat.MMMM().format(this);
  }
}
