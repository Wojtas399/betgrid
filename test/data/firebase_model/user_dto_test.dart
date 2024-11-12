import 'package:betgrid/data/firebase/model/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/user_creator.dart';

void main() {
  const String id = 'u1';
  const String username = 'username';
  const UserCreatorThemeMode themeMode = UserCreatorThemeMode.system;
  const UserCreatorThemePrimaryColor themePrimaryColor =
      UserCreatorThemePrimaryColor.purple;

  test(
    'fromJson, '
    'should map json model to class model ignoring id',
    () {
      const creator = UserCreator(
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      final Map<String, Object?> json = creator.createJson();
      final UserDto expectedModel = creator.createDto();

      final UserDto model = UserDto.fromJson(json);

      expect(model, expectedModel);
    },
  );

  test(
    'fromFirebase, '
    'should map json model to class model with given id',
    () {
      const creator = UserCreator(
        id: id,
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      final Map<String, Object?> json = creator.createJson();
      final UserDto expectedModel = creator.createDto();

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
      const creator = UserCreator(
        id: id,
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      final UserDto model = creator.createDto();
      final Map<String, Object?> expectedJson = creator.createJson();

      final Map<String, Object?> json = model.toJson();

      expect(json, expectedJson);
    },
  );
}
