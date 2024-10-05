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
    'initial state should be empty list',
    () async {
      repository = TestRepository();

      final state = await repository.repositoryState$.first;

      expect(state, []);
    },
  );

  group(
    'isRepositoryStateEmpty, ',
    () {
      test(
        'should return true if repository state is empty array',
        () {
          repository = TestRepository();

          expect(repository.isRepositoryStateEmpty, true);
        },
      );

      test(
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

  group(
    'addEntity, ',
    () {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];

      setUp(() {
        repository = TestRepository(initialData: existingEntities);
      });

      test(
        'should throw exception if entity with the same id already exists in '
        'state',
        () {
          const TestModel newEntity = TestModel(id: 'e1', name: 'entity 1');
          final String expectedException =
              '[Repository] Entity $newEntity already exists in repository state';

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
        'should add new entity to state',
        () {
          const TestModel newEntity = TestModel(id: 'e3', name: 'entity 3');
          final List<TestModel> expectedEntities = [
            ...existingEntities,
            newEntity,
          ];

          repository.addEntity(newEntity);

          expect(repository.repositoryState$, emits(expectedEntities));
        },
      );
    },
  );

  group(
    'addEntities, ',
    () {
      const List<TestModel> existingEntities = [
        TestModel(id: 'e3', name: 'third entity'),
        TestModel(id: 'e4', name: 'fourth entity'),
        TestModel(id: 'e5', name: 'fifth entity'),
      ];

      setUp(() {
        repository = TestRepository(initialData: existingEntities);
      });

      test(
        'should throw exception if list of entities to add is empty',
        () {
          const List<TestModel> entitiesToAdd = [];
          final String expectedException =
              '[Repository] List of entities (type $TestModel) to add is empty';

          Object? exception;
          try {
            repository.addEntities(entitiesToAdd);
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedException);
        },
      );

      test(
        'should throw exception if one of the entities already exists in state',
        () {
          const List<TestModel> entitiesToAdd = [
            TestModel(id: 'e1', name: 'first entity'),
            TestModel(id: 'e2', name: 'second entity'),
            TestModel(id: 'e3', name: 'third entity'),
          ];
          final String expectedException =
              '[Repository] Entity ${entitiesToAdd[2]} already exists in repository state';

          Object? exception;
          try {
            repository.addEntities(entitiesToAdd);
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedException);
        },
      );

      test(
        'should add all passed entities to state',
        () {
          const List<TestModel> entitiesToAdd = [
            TestModel(id: 'e1', name: 'first entity'),
            TestModel(id: 'e2', name: 'second entity'),
          ];
          final List<TestModel> expectedEntities = [
            ...existingEntities,
            ...entitiesToAdd,
          ];

          repository.addEntities(entitiesToAdd);

          expect(repository.repositoryState$, emits(expectedEntities));
        },
      );
    },
  );

  group(
    'addOrUpdateEntities, ',
    () {
      final List<TestModel> existingEntities = [
        TestModel(id: 'e1', name: 'entity 1'),
        TestModel(id: 'e2', name: 'entity 2'),
        TestModel(id: 'e3', name: 'entity 3'),
      ];

      setUp(() {
        repository = TestRepository(initialData: existingEntities);
      });

      test(
        'should do nothing if list of entities to add or update is empty',
        () {
          final List<TestModel> entitiesToAddOrUpdate = [];

          repository.addOrUpdateEntities(entitiesToAddOrUpdate);

          expect(repository.repositoryState$, emits(existingEntities));
        },
      );

      test(
        'should add new entities and update existing entities',
        () {
          final List<TestModel> entitiesToAddOrUpdate = [
            TestModel(id: 'e1', name: 'updated entity 1'),
            TestModel(id: 'e3', name: 'updated entity 3'),
            TestModel(id: 'e4', name: 'entity 4'),
            TestModel(id: 'e5', name: 'entity 5'),
          ];
          final List<TestModel> expectedUpdatedRepoState = [
            entitiesToAddOrUpdate.first,
            existingEntities[1],
            entitiesToAddOrUpdate[1],
            entitiesToAddOrUpdate[2],
            entitiesToAddOrUpdate.last,
          ];

          repository.addOrUpdateEntities(entitiesToAddOrUpdate);

          expect(repository.repositoryState$, emits(expectedUpdatedRepoState));
        },
      );
    },
  );

  group(
    'updateEntity, ',
    () {
      const List<TestModel> existingEntities = [
        TestModel(id: 'e1', name: 'entity 1'),
        TestModel(id: 'e2', name: 'entity 2'),
        TestModel(id: 'e3', name: 'entity 3'),
      ];

      setUp(() {
        repository = TestRepository(initialData: existingEntities);
      });

      test(
        'should do nothing if entity does not exist in state',
        () {
          const TestModel updateEntity = TestModel(
            id: 'e4',
            name: 'entity 4',
          );

          repository.updateEntity(updateEntity);

          expect(repository.repositoryState$, emits(existingEntities));
        },
      );

      test(
        'should update entity in state',
        () {
          const TestModel updateEntity = TestModel(
            id: 'e2',
            name: 'updated entity 2',
          );

          repository.updateEntity(updateEntity);

          expect(
            repository.repositoryState$,
            emits(
              [existingEntities.first, updateEntity, existingEntities.last],
            ),
          );
        },
      );
    },
  );
}
