import '../../../model/team_basic_info.dart';

abstract interface class TeamBasicInfoRepository {
  Stream<List<TeamBasicInfo>> getAll();

  Stream<TeamBasicInfo?> getById(String id);

  Future<void> add({required String name, required String hexColor});

  Future<void> deleteById(String id);
}
