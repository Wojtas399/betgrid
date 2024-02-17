import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDayAndMonthName() => DateFormat('dd MMM').format(this);
}

String twoDigits(int number) => number.toString().padLeft(2, '0');
