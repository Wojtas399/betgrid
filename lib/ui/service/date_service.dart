import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();

  Stream<DateTime> getNowStream() => Stream.periodic(
        const Duration(seconds: 1),
        (_) => getNow(),
      );

  bool isDateABeforeDateB(DateTime dateA, DateTime dateB) =>
      dateA.year == dateB.year
          ? dateA.month == dateB.month
              ? dateA.day < dateB.day
              : dateA.month < dateB.month
          : dateA.year < dateB.year;

  Duration getDurationToDateFromNow(DateTime dateTime) {
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return date.difference(DateTime.now());
  }
}
