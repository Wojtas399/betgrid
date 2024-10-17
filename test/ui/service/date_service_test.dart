import 'package:betgrid/ui/service/date_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = DateService();

  group(
    'isDateABeforeDateB',
    () {
      test(
        'should return true if year of date A is lower than year of date B',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2025, 3, 3, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, true);
        },
      );

      test(
        'should return false if year of date A is higher than year of date B',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2023, 3, 3, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, false);
        },
      );

      test(
        'should return true if years in both dates are the same but month of '
        'date A is lower than month of date B',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2024, 3, 3, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, true);
        },
      );

      test(
        'should return false if years in both dates are the same but month of '
        'date A is higher than month of date B',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2024, 1, 3, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, false);
        },
      );

      test(
        'should return true if years and months in both dates are the same but '
        'day of date A is lower than day of date B',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2024, 2, 3, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, true);
        },
      );

      test(
        'should return false if years and months in both dates are the same '
        'but day of date A is higher than day of date B',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2024, 2, 1, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, false);
        },
      );

      test(
        'should return false if years, months and days in both dates are the '
        'same',
        () {
          final dateA = DateTime(2024, 2, 2, 2, 2, 2);
          final dateB = DateTime(2024, 2, 2, 3, 3, 3);

          final bool answer = service.isDateABeforeDateB(dateA, dateB);

          expect(answer, false);
        },
      );
    },
  );
}
