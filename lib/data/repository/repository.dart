import 'package:collection/collection.dart';
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
    final bool doesEntityExist = _repositoryState$.value?.firstWhereOrNull(
          (element) => element.id == entity.id,
        ) !=
        null;
    if (doesEntityExist) {
      throw '[Repository] Entity $entity already exists in repository state';
    }
    final List<T> entities = [...?_repositoryState$.value];
    entities.add(entity);
    _repositoryState$.add(entities);
  }

  void updateEntity(T entity) {
    final List<T> entities = [...?_repositoryState$.value];
    final int entityIndex = entities.indexWhere(
      (element) => element.id == entity.id,
    );
    if (entityIndex >= 0) {
      entities[entityIndex] = entity;
      _repositoryState$.add(entities);
    }
  }
}
