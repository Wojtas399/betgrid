import 'package:injectable/injectable.dart';

import '../repository.dart';
import '../../../model/{{model_name.snakeCase()}}.dart';
import '{{model_name.snakeCase()}}_repository.dart';

@LazySingleton(as: {{model_name.pascalCase()}}Repository)
class {{model_name.pascalCase()}}RepositoryImpl extends Repository<{{model_name.pascalCase()}}>
    implements {{model_name.pascalCase()}}Repository {
  {{model_name.pascalCase()}}RepositoryImpl();

  //TODO: Add method implementations
}