import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_service.g.dart';

class DateService {
  DateTime getNow() => DateTime.now();
}

@riverpod
DateService dateService(DateServiceRef ref) => DateService();
