import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../model/grand_prix_basic_info.dart';
import '../../firebase/model/grand_prix_basic_info_dto.dart';
import '../../firebase/service/firebase_grand_prix_basic_info_service.dart';
import '../../mapper/grand_prix_basic_info_mapper.dart';
import '../repository.dart';
import 'grand_prix_basic_info_repository.dart';

@LazySingleton(as: GrandPrixBasicInfoRepository)
class GrandPrixBasicInfoRepositoryImpl extends Repository<GrandPrixBasicInfo>
    implements GrandPrixBasicInfoRepository {
  final FirebaseGrandPrixBasicInfoService _firebaseGrandPrixBasicInfoService;
  final GrandPrixBasicInfoMapper _grandPrixBasicInfoMapper;

  GrandPrixBasicInfoRepositoryImpl(
    this._firebaseGrandPrixBasicInfoService,
    this._grandPrixBasicInfoMapper,
  );

  @override
  Stream<GrandPrixBasicInfo?> getGrandPrixBasicInfoById(String id) async* {
    await for (final grandPrixesBasicInfo in repositoryState$) {
      GrandPrixBasicInfo? matchingGrandPrixBasicInfo =
          grandPrixesBasicInfo.firstWhereOrNull(
        (GrandPrixBasicInfo grandPrixBasicInfo) => grandPrixBasicInfo.id == id,
      );
      matchingGrandPrixBasicInfo ??= await _fetchGrandPrixBasicInfoById(id);
      yield matchingGrandPrixBasicInfo;
    }
  }

  Future<GrandPrixBasicInfo?> _fetchGrandPrixBasicInfoById(String id) async {
    final GrandPrixBasicInfoDto? grandPrixBasicInfoDto =
        await _firebaseGrandPrixBasicInfoService
            .fetchGrandPrixBasicInfoById(id);
    if (grandPrixBasicInfoDto == null) return null;
    final GrandPrixBasicInfo grandPrixBasicInfo =
        _grandPrixBasicInfoMapper.mapFromDto(grandPrixBasicInfoDto);
    addEntity(grandPrixBasicInfo);
    return grandPrixBasicInfo;
  }
}
