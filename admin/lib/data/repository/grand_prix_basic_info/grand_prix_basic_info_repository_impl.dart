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
  final FirebaseGrandPrixBasicInfoService _firebaseGrandPrixBasicInfoService;
  final GrandPrixBasicInfoMapper _grandPrixBasicInfoMapper;
  final _getByIdMutex = Mutex();

  GrandPrixBasicInfoRepositoryImpl(
    this._firebaseGrandPrixBasicInfoService,
    this._grandPrixBasicInfoMapper,
  );

  @override
  Stream<Iterable<GrandPrixBasicInfo>> getAll() async* {
    await _fetchAll();
    await for (final allGrandPrixesBasicInfo in repositoryState$) {
      yield allGrandPrixesBasicInfo;
    }
  }

  @override
  Stream<GrandPrixBasicInfo?> getById(String id) async* {
    bool didRelease = false;
    await _getByIdMutex.acquire();
    await for (final entities in repositoryState$) {
      GrandPrixBasicInfo? matchingEntity = entities.firstWhereOrNull(
        (entity) => entity.id == id,
      );
      matchingEntity ??= await _fetchById(id);
      if (_getByIdMutex.isLocked && !didRelease) {
        _getByIdMutex.release();
        didRelease = true;
      }
      yield matchingEntity;
    }
  }

  @override
  Future<void> add({
    required String name,
    required String countryAlpha2Code,
  }) async {
    final GrandPrixBasicInfoDto? addedGrandPrixBasicInfoDto =
        await _firebaseGrandPrixBasicInfoService.add(
          name: name,
          countryAlpha2Code: countryAlpha2Code,
        );
    if (addedGrandPrixBasicInfoDto != null) {
      final GrandPrixBasicInfo addedGrandPrixBasicInfo =
          _grandPrixBasicInfoMapper.mapFromDto(addedGrandPrixBasicInfoDto);
      addEntity(addedGrandPrixBasicInfo);
    }
  }

  @override
  Future<void> deleteById(String id) async {
    await _firebaseGrandPrixBasicInfoService.deleteById(id);
    deleteEntity(id);
  }

  Future<void> _fetchAll() async {
    final Iterable<GrandPrixBasicInfoDto> dtos =
        await _firebaseGrandPrixBasicInfoService.fetchAll();
    if (dtos.isNotEmpty) {
      final Iterable<GrandPrixBasicInfo> entities = dtos.map(
        _grandPrixBasicInfoMapper.mapFromDto,
      );
      addOrUpdateEntities(entities);
    }
  }

  Future<GrandPrixBasicInfo?> _fetchById(String id) async {
    final GrandPrixBasicInfoDto? dto = await _firebaseGrandPrixBasicInfoService
        .fetchById(id);
    if (dto == null) return null;
    final GrandPrixBasicInfo entity = _grandPrixBasicInfoMapper.mapFromDto(dto);
    addEntity(entity);
    return entity;
  }
}
