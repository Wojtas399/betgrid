import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/data/mapper/theme_mode_mapper.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeModeMapper extends Mock implements ThemeModeMapper {
  MockThemeModeMapper() {
    registerFallbackValue(ThemeModeDto.light);
  }

  void mockMapFromDto({
    required ThemeMode expectedThemeMode,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedThemeMode);
  }
}
