import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();

  Stream<DateTime> getNowStream() =>
      Stream.periodic(const Duration(seconds: 1), (_) => getNow());

  bool isDateABeforeDateB(DateTime dateA, DateTime dateB) =>
      dateA.year == dateB.year
          ? dateA.month == dateB.month
              ? dateA.day < dateB.day
              : dateA.month < dateB.month
          : dateA.year < dateB.year;

  Duration getDurationBetweenDateTimes({
    required DateTime fromDateTime,
    required DateTime toDateTime,
  }) {
    return toDateTime.difference(fromDateTime);
  }
}
