import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/data/mapper/theme_primary_color_mapper.dart';
import 'package:betgrid/model/user.dart';
import 'package:mocktail/mocktail.dart';

class MockThemePrimaryColorMapper extends Mock
    implements ThemePrimaryColorMapper {
  MockThemePrimaryColorMapper() {
    registerFallbackValue(ThemePrimaryColorDto.defaultRed);
  }

  void mockMapFromDto({
    required ThemePrimaryColor expectedThemePrimaryColor,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedThemePrimaryColor);
  }
}
