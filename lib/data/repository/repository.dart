import 'package:rxdart/rxdart.dart';

import '../../model/entity.dart';

abstract class Repository<T extends Entity> {
  final BehaviorSubject<List<T>?> _repositoryState$ =
      BehaviorSubject<List<T>?>.seeded(null);

  Repository({List<T>? initialData}) {
    _repositoryState$.add(initialData);
  }

  Stream<List<T>?> get repositoryState$ => _repositoryState$.stream;

  bool get isRepositoryStateNotInitialized => _repositoryState$.value == null;

  bool get isRepositoryStateEmpty => _repositoryState$.value?.isEmpty == true;

  void close() {
    _repositoryState$.close();
  }

  void setEntities(List<T> entities) {
    _repositoryState$.add(entities);
  }

  void addEntity(T entity) {
    final List<T> entities = [...?_repositoryState$.value];
    entities.add(entity);
    _repositoryState$.add(entities);
  }
}
