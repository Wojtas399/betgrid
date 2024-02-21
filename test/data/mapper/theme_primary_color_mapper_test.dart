import 'package:betgrid/data/mapper/theme_primary_color_mapper.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.defaultRed should be mapped to ThemePrimaryColor.defaultRed',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.defaultRed;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.pink should be mapped to ThemePrimaryColor.pink',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.pink;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.pink;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.purple should be mapped to ThemePrimaryColor.purple',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.purple;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.purple;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.purple should be mapped to ThemePrimaryColor.purple',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.purple;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.purple;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.brown should be mapped to ThemePrimaryColor.brown',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.brown;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.brown;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.orange should be mapped to ThemePrimaryColor.orange',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.orange;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.orange;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.yellow should be mapped to ThemePrimaryColor.yellow',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.yellow;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.yellow;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.green should be mapped to ThemePrimaryColor.green',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.green;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.green;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorFromDto, '
    'ThemePrimaryColorDto.blue should be mapped to ThemePrimaryColor.blue',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.blue;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.blue;

      final ThemePrimaryColor themePrimaryColor =
          mapThemePrimaryColorFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.defaultRed should be mapped to ThemePrimaryColorDto.defaultRed',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.pink should be mapped to ThemePrimaryColorDto.pink',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.pink;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.purple should be mapped to ThemePrimaryColorDto.purple',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.purple;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.purple;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.brown should be mapped to ThemePrimaryColorDto.brown',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.brown;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.brown;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.orange should be mapped to ThemePrimaryColorDto.orange',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.orange;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.orange;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.yellow should be mapped to ThemePrimaryColorDto.yellow',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.yellow;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.yellow;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.green should be mapped to ThemePrimaryColorDto.green',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.green;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.green;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapThemePrimaryColorToDto, '
    'ThemePrimaryColor.blue should be mapped to ThemePrimaryColorDto.blue',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.blue;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.blue;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapThemePrimaryColorToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );
}
