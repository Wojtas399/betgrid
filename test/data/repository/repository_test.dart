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
    'should set given entities in state',
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
}
