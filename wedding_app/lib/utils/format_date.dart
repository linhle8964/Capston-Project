import 'package:intl/intl.dart';

String convertDateTimeToString(DateTime dateTime){
  return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
}