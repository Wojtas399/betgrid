import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/entity.dart';

abstract class Repository<T extends Entity> {
  final BehaviorSubject<List<T>> _repositoryState$ =
      BehaviorSubject<List<T>>.seeded([]);

  Repository({List<T> initialData = const []}) {
    _repositoryState$.add(initialData);
  }

  Stream<List<T>> get repositoryState$ => _repositoryState$.stream;

  bool get isRepositoryStateEmpty => _repositoryState$.value.isEmpty == true;

  void setEntities(List<T> entities) {
    _repositoryState$.add(entities);
  }

  void addEntity(T entity) {
    final bool doesEntityExist =
        _repositoryState$.value.firstWhereOrNull(
          (element) => element.id == entity.id,
        ) !=
        null;
    if (doesEntityExist) {
      throw '[Repository] Entity $entity already exists in repository state';
    }
    final List<T> entities = [..._repositoryState$.value];
    entities.add(entity);
    _repositoryState$.add(entities);
  }

  void addEntities(Iterable<T> entities) {
    if (entities.isEmpty) {
      throw '[Repository] List of entities (type $T) to add is empty';
    }
    final List<T> updatedEntities = [..._repositoryState$.value];
    for (final entity in entities) {
      final bool doesEntityExist =
          updatedEntities.firstWhereOrNull(
            (element) => element.id == entity.id,
          ) !=
          null;
      if (doesEntityExist) {
        throw '[Repository] Entity $entity already exists in repository state';
      }
      updatedEntities.add(entity);
    }
    _repositoryState$.add(updatedEntities);
  }

  void addOrUpdateEntities(Iterable<T> entitiesToAddOrUpdate) {
    if (entitiesToAddOrUpdate.isEmpty) return;
    final List<T> updatedEntities = [..._repositoryState$.value];
    for (final entity in entitiesToAddOrUpdate) {
      final int existingEntityIndex = updatedEntities.indexWhere(
        (element) => element.id == entity.id,
      );
      if (existingEntityIndex >= 0) {
        updatedEntities[existingEntityIndex] = entity;
      } else {
        updatedEntities.add(entity);
      }
    }
    _repositoryState$.add(updatedEntities);
  }

  void updateEntity(T entity) {
    final List<T> entities = [..._repositoryState$.value];
    final int entityIndex = entities.indexWhere(
      (element) => element.id == entity.id,
    );
    if (entityIndex >= 0) {
      entities[entityIndex] = entity;
      _repositoryState$.add(entities);
    }
  }
}
