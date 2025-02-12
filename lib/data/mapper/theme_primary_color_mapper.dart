import 'package:betgrid_shared/firebase/model/user_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/user.dart';

@injectable
class ThemePrimaryColorMapper {
  ThemePrimaryColor mapFromDto(
    ThemePrimaryColorDto themePrimaryColorDto,
  ) =>
      switch (themePrimaryColorDto) {
        ThemePrimaryColorDto.red => ThemePrimaryColor.defaultRed,
        ThemePrimaryColorDto.pink => ThemePrimaryColor.pink,
        ThemePrimaryColorDto.purple => ThemePrimaryColor.purple,
        ThemePrimaryColorDto.brown => ThemePrimaryColor.brown,
        ThemePrimaryColorDto.orange => ThemePrimaryColor.orange,
        ThemePrimaryColorDto.yellow => ThemePrimaryColor.yellow,
        ThemePrimaryColorDto.green => ThemePrimaryColor.green,
        ThemePrimaryColorDto.blue => ThemePrimaryColor.blue,
      };

  ThemePrimaryColorDto mapToDto(
    ThemePrimaryColor themePrimaryColor,
  ) =>
      switch (themePrimaryColor) {
        ThemePrimaryColor.defaultRed => ThemePrimaryColorDto.red,
        ThemePrimaryColor.pink => ThemePrimaryColorDto.pink,
        ThemePrimaryColor.purple => ThemePrimaryColorDto.purple,
        ThemePrimaryColor.brown => ThemePrimaryColorDto.brown,
        ThemePrimaryColor.orange => ThemePrimaryColorDto.orange,
        ThemePrimaryColor.yellow => ThemePrimaryColorDto.yellow,
        ThemePrimaryColor.green => ThemePrimaryColorDto.green,
        ThemePrimaryColor.blue => ThemePrimaryColorDto.blue,
      };
}
