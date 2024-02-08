extension DateTimeExtensions on DateTime {
  String toDayAndMonth() => '${twoDigits(day)}.${twoDigits(month)}';
}

String twoDigits(int number) => number.toString().padLeft(2, '0');
