import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '{{screen_name.snakeCase()}}_state.dart';

@injectable
class {{screen_name.pascalCase()}}Cubit extends Cubit<{{screen_name.pascalCase()}}State> {
  {{screen_name.pascalCase()}}Cubit() : super(const {{screen_name.pascalCase()}}State());
}