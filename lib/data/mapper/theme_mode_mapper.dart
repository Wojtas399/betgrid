import 'package:betgrid_shared/firebase/model/user_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/user.dart';

@injectable
class ThemeModeMapper {
  ThemeMode mapFromDto(ThemeModeDto themeModeDto) => switch (themeModeDto) {
        ThemeModeDto.light => ThemeMode.light,
        ThemeModeDto.dark => ThemeMode.dark,
        ThemeModeDto.system => ThemeMode.system,
      };

  ThemeModeDto mapToDto(ThemeMode themeMode) => switch (themeMode) {
        ThemeMode.light => ThemeModeDto.light,
        ThemeMode.dark => ThemeModeDto.dark,
        ThemeMode.system => ThemeModeDto.system,
      };
}
