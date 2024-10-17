import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();

  bool isDateABeforeDateB(DateTime dateA, DateTime dateB) =>
      dateA.year == dateB.year
          ? dateA.month == dateB.month
              ? dateA.day < dateB.day
              : dateA.month < dateB.month
          : dateA.year < dateB.year;
}
