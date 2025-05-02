import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDayAndMonthName() => DateFormat('dd MMM').format(this);

  String toFullDate() => DateFormat('dd MMM yyyy').format(this);

  bool isDateAfter(DateTime otherDateTime) {
    final DateTime thisDate = DateTime(year, month, day);
    final DateTime otherDate = DateTime(
      otherDateTime.year,
      otherDateTime.month,
      otherDateTime.day,
    );
    return thisDate.isAfter(otherDate);
  }

  bool isDateBefore(DateTime otherDateTime) {
    final DateTime thisDate = DateTime(year, month, day);
    final DateTime otherDate = DateTime(
      otherDateTime.year,
      otherDateTime.month,
      otherDateTime.day,
    );
    return thisDate.isBefore(otherDate);
  }
}
