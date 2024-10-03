import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'u1';
  const String username = 'username';
  const ThemeModeDto themeMode = ThemeModeDto.system;
  const ThemePrimaryColorDto themePrimaryColor = ThemePrimaryColorDto.purple;

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      final Map<String, Object?> json = {
        'username': username,
        'themeMode': 'system',
        'themePrimaryColor': 'purple',
      };
      const UserDto expectedModel = UserDto(
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      final UserDto model = UserDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      final Map<String, Object?> json = {
        'username': username,
        'themeMode': 'system',
        'themePrimaryColor': 'purple',
      };
      const UserDto expectedModel = UserDto(
        id: id,
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      final UserDto model = UserDto.fromFirebase(
        id: id,
        json: json,
      );

      expect(model, expectedModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model ignoring id',
    () {
      const UserDto model = UserDto(
        id: id,
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      final Map<String, Object?> expectedJson = {
        'username': username,
        'themeMode': 'system',
        'themePrimaryColor': 'purple',
      };

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
