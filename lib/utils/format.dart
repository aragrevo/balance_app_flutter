import 'package:intl/intl.dart';

String toCapitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

String toCurrency(dynamic value) {
  return NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0)
      .format(value);
}
