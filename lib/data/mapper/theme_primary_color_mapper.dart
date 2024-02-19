import '../../firebase/model/user_dto/user_dto.dart';
import '../../model/user.dart';

ThemePrimaryColor mapThemePrimaryColorFromDto(
  ThemePrimaryColorDto themePrimaryColorDto,
) =>
    switch (themePrimaryColorDto) {
      ThemePrimaryColorDto.defaultRed => ThemePrimaryColor.defaultRed,
      ThemePrimaryColorDto.pink => ThemePrimaryColor.pink,
      ThemePrimaryColorDto.purple => ThemePrimaryColor.purple,
      ThemePrimaryColorDto.orange => ThemePrimaryColor.orange,
      ThemePrimaryColorDto.yellow => ThemePrimaryColor.yellow,
      ThemePrimaryColorDto.green => ThemePrimaryColor.green,
      ThemePrimaryColorDto.teal => ThemePrimaryColor.teal,
      ThemePrimaryColorDto.blue => ThemePrimaryColor.blue,
    };

ThemePrimaryColorDto mapThemePrimaryColorToDto(
  ThemePrimaryColor themePrimaryColor,
) =>
    switch (themePrimaryColor) {
      ThemePrimaryColor.defaultRed => ThemePrimaryColorDto.defaultRed,
      ThemePrimaryColor.pink => ThemePrimaryColorDto.pink,
      ThemePrimaryColor.purple => ThemePrimaryColorDto.purple,
      ThemePrimaryColor.orange => ThemePrimaryColorDto.orange,
      ThemePrimaryColor.yellow => ThemePrimaryColorDto.yellow,
      ThemePrimaryColor.green => ThemePrimaryColorDto.green,
      ThemePrimaryColor.teal => ThemePrimaryColorDto.teal,
      ThemePrimaryColor.blue => ThemePrimaryColorDto.blue,
    };
