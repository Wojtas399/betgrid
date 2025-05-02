import 'package:betgrid_admin/data/repository/{{model_name.snakeCase()}}/{{model_name.snakeCase()}}_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late {{model_name.pascalCase()}}RepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = {{model_name.pascalCase()}}RepositoryImpl();
  });
}