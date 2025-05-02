import 'package:betgrid_shared/firebase/model/grand_prix_basic_info_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_basic_info_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/grand_prix_basic_info.dart';
import '../../mapper/grand_prix_basic_info_mapper.dart';
import '../repository.dart';
import 'grand_prix_basic_info_repository.dart';

@LazySingleton(as: GrandPrixBasicInfoRepository)
class GrandPrixBasicInfoRepositoryImpl extends Repository<GrandPrixBasicInfo>
    implements GrandPrixBasicInfoRepository {
  final FirebaseGrandPrixBasicInfoService _fireGrandPrixBasicInfoService;
  final GrandPrixBasicInfoMapper _grandPrixBasicInfoMapper;
  final _getGrandPrixBasicInfoByIdMutex = Mutex();

  GrandPrixBasicInfoRepositoryImpl(
    this._fireGrandPrixBasicInfoService,
    this._grandPrixBasicInfoMapper,
  );

  @override
  Stream<GrandPrixBasicInfo?> getById(String id) async* {
    bool didReleaseMutex = false;
    await _getGrandPrixBasicInfoByIdMutex.acquire();
    await for (final grandPrixesBasicInfo in repositoryState$) {
      GrandPrixBasicInfo? matchingGrandPrixBasicInfo = grandPrixesBasicInfo
          .firstWhereOrNull(
            (GrandPrixBasicInfo grandPrixBasicInfo) =>
                grandPrixBasicInfo.id == id,
          );
      matchingGrandPrixBasicInfo ??= await _fetchById(id);
      if (_getGrandPrixBasicInfoByIdMutex.isLocked && !didReleaseMutex) {
        _getGrandPrixBasicInfoByIdMutex.release();
        didReleaseMutex = true;
      }
      yield matchingGrandPrixBasicInfo;
    }
  }

  Future<GrandPrixBasicInfo?> _fetchById(String id) async {
    final GrandPrixBasicInfoDto? grandPrixBasicInfoDto =
        await _fireGrandPrixBasicInfoService.fetchById(id);
    if (grandPrixBasicInfoDto == null) return null;
    final GrandPrixBasicInfo grandPrixBasicInfo = _grandPrixBasicInfoMapper
        .mapFromDto(grandPrixBasicInfoDto);
    addEntity(grandPrixBasicInfo);
    return grandPrixBasicInfo;
  }
}
