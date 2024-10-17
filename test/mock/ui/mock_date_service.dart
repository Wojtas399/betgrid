import 'package:betgrid/ui/service/date_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDateService extends Mock implements DateService {
  void mockGetNow({required DateTime now}) {
    when(getNow).thenReturn(now);
  }

  void mockIsDateABeforeDateB({
    required bool expected,
  }) {
    when(
      () => isDateABeforeDateB(any(), any()),
    ).thenReturn(expected);
  }
}
