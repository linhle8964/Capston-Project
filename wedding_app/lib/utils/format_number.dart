import 'package:intl/intl.dart';

String formatNumber(String s) =>
    NumberFormat.decimalPattern('en').format(int.parse(s));

String formatCurrency(String s) {
  return NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(s));
}
