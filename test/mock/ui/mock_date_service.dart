import 'package:betgrid/ui/service/date_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDateService extends Mock implements DateService {
  void mockGetNow({required DateTime now}) {
    when(getNow).thenReturn(now);
  }

  void mockGetNowStream({
    required DateTime expectedNow,
  }) {
    when(getNowStream).thenAnswer((_) => Stream.value(expectedNow));
  }

  void mockIsDateABeforeDateB({
    required bool expected,
  }) {
    when(
      () => isDateABeforeDateB(any(), any()),
    ).thenReturn(expected);
  }

  void mockGetDurationToDateFromNow({
    required Duration duration,
  }) {
    when(
      () => getDurationToDateFromNow(any()),
    ).thenReturn(duration);
  }
}
