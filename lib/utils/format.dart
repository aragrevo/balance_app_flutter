import 'package:intl/intl.dart';

String toCurrency(dynamic value) {
  if (value == null || value == '') return value;
  if (value is String) {
    value = int.parse(value);
  }
  return NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0)
      .format(value);
}

String toSmallCurrency(dynamic value) {
  final currency = toCurrency(value);
  if (currency.length < 4) return currency;
  return '${currency.substring(0, currency.length - 4)} k';
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
