import 'package:freezed_annotation/freezed_annotation.dart';

part '{{screen_name.snakeCase()}}_state.freezed.dart';

enum {{screen_name.pascalCase()}}StateStatus {
  loading,
  completed,
}

@freezed
class {{screen_name.pascalCase()}}State with _${{screen_name.pascalCase()}}State {
  const factory {{screen_name.pascalCase()}}State({
    @Default({{screen_name.pascalCase()}}StateStatus.loading)
    {{screen_name.pascalCase()}}StateStatus status,
  }) = _{{screen_name.pascalCase()}}State;
}