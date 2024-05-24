import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();
}
