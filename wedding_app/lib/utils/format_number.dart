import 'package:intl/intl.dart';

String formatNumber(String s) =>
    NumberFormat.decimalPattern('en').format(int.parse(s));
