import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_service.g.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();
}

@riverpod
DateService dateService(DateServiceRef ref) => DateService();
