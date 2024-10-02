import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/data/mapper/theme_primary_color_mapper.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mapper = ThemePrimaryColorMapper();

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.defaultRed should be mapped to ThemePrimaryColor.defaultRed',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.defaultRed;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.pink should be mapped to ThemePrimaryColor.pink',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.pink;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.pink;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.purple should be mapped to ThemePrimaryColor.purple',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.purple;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.purple;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.purple should be mapped to ThemePrimaryColor.purple',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.purple;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.purple;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.brown should be mapped to ThemePrimaryColor.brown',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.brown;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.brown;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.orange should be mapped to ThemePrimaryColor.orange',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.orange;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.orange;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.yellow should be mapped to ThemePrimaryColor.yellow',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.yellow;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.yellow;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.green should be mapped to ThemePrimaryColor.green',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.green;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.green;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapFromDto, '
    'ThemePrimaryColorDto.blue should be mapped to ThemePrimaryColor.blue',
    () {
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.blue;
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.blue;

      final ThemePrimaryColor themePrimaryColor =
          mapper.mapFromDto(themePrimaryColorDto);

      expect(themePrimaryColor, expectedThemePrimaryColor);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.defaultRed should be mapped to ThemePrimaryColorDto.defaultRed',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.pink should be mapped to ThemePrimaryColorDto.pink',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.pink;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.pink;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.purple should be mapped to ThemePrimaryColorDto.purple',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.purple;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.purple;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.brown should be mapped to ThemePrimaryColorDto.brown',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.brown;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.brown;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.orange should be mapped to ThemePrimaryColorDto.orange',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.orange;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.orange;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.yellow should be mapped to ThemePrimaryColorDto.yellow',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.yellow;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.yellow;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.green should be mapped to ThemePrimaryColorDto.green',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.green;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.green;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );

  test(
    'mapToDto, '
    'ThemePrimaryColor.blue should be mapped to ThemePrimaryColorDto.blue',
    () {
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.blue;
      const ThemePrimaryColorDto expectedThemePrimaryColorDto =
          ThemePrimaryColorDto.blue;

      final ThemePrimaryColorDto themePrimaryColorDto =
          mapper.mapToDto(themePrimaryColor);

      expect(themePrimaryColorDto, expectedThemePrimaryColorDto);
    },
  );
}
