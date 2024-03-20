import 'package:betgrid/data/repository/repository.dart';
import 'package:betgrid/model/entity.dart';
import 'package:flutter_test/flutter_test.dart';

class TestModel extends Entity {
  final String name;

  const TestModel({required super.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class TestRepository extends Repository<TestModel> {
  TestRepository({super.initialData});
}

void main() {
  late Repository repository;

  setUp(() {
    repository = TestRepository();
  });

  test(
    'isRepositoryStateNotInitialized, '
    'should return true if repository state is null',
    () {
      expect(repository.isRepositoryStateNotInitialized, true);
    },
  );

  test(
    'isRepositoryStateNotInitialized, '
    'should return false if repository state is not null',
    () {
      repository = TestRepository(initialData: []);

      expect(repository.isRepositoryStateNotInitialized, false);
    },
  );

  test(
    'isRepositoryStateEmpty, '
    'should return true if repository state is empty array',
    () {
      repository = TestRepository(initialData: []);

      expect(repository.isRepositoryStateEmpty, true);
    },
  );

  test(
    'isRepositoryStateEmpty, '
    'should return false if repository state is not empty array',
    () {
      repository = TestRepository(
        initialData: [
          const TestModel(id: 'id', name: 'name'),
        ],
      );

      expect(repository.isRepositoryStateEmpty, false);
    },
  );

  test(
    'setEntities, '
    'should set given entities as new state',
    () {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final List<TestModel> newEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e3', name: 'third entity'),
        const TestModel(id: 'e4', name: 'fourth entity'),
      ];
      repository = TestRepository(initialData: existingEntities);

      repository.setEntities(newEntities);

      expect(repository.repositoryState$, emits(newEntities));
    },
  );

  test(
    'addEntity, '
    'entity with the same id already exists in state, '
    'should throw exception',
    () {
      const TestModel newEntity = TestModel(id: 'e1', name: 'entity 1');
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final String expectedException =
          '[Repository] Entity $newEntity already exists in repository state';
      repository = TestRepository(initialData: existingEntities);

      Object? exception;
      try {
        repository.addEntity(newEntity);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
    },
  );

  test(
    'addEntity, '
    'should add new entity to state',
    () {
      const TestModel newEntity = TestModel(id: 'e3', name: 'entity 3');
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final List<TestModel> expectedEntities = [
        ...existingEntities,
        newEntity,
      ];
      repository = TestRepository(initialData: existingEntities);

      repository.addEntity(newEntity);

      expect(repository.repositoryState$, emits(expectedEntities));
    },
  );

  test(
    'updateEntity, '
    'repository state is not initialized, '
    'should do nothing',
    () {
      const TestModel updateEntity = TestModel(id: 'e2', name: 'entity 2');

      repository.updateEntity(updateEntity);

      expect(repository.repositoryState$, emits(null));
    },
  );

  test(
    'updateEntity, '
    'entity does not exist in state, '
    'should do nothing',
    () {
      const TestModel updateEntity = TestModel(id: 'e2', name: 'entity 2');
      const List<TestModel> existingEntities = [
        TestModel(id: 'e1', name: 'entity 1'),
        TestModel(id: 'e3', name: 'entity 3'),
      ];
      repository = TestRepository(initialData: existingEntities);

      repository.updateEntity(updateEntity);

      expect(repository.repositoryState$, emits(existingEntities));
    },
  );

  test(
    'updateEntity, '
    'should update entity in state',
    () {
      const TestModel updateEntity = TestModel(
        id: 'e2',
        name: 'updated entity 2',
      );
      const List<TestModel> existingEntities = [
        TestModel(id: 'e1', name: 'entity 1'),
        TestModel(id: 'e2', name: 'entity 2'),
        TestModel(id: 'e3', name: 'entity 3'),
      ];
      repository = TestRepository(initialData: existingEntities);

      repository.updateEntity(updateEntity);

      expect(
        repository.repositoryState$,
        emits([existingEntities.first, updateEntity, existingEntities.last]),
      );
    },
  );
}
