import 'package:betgrid/data/firebase/model/driver_personal_data_dto.dart';
import 'package:betgrid/data/repository/driver_personal_data/driver_personal_data_repository_impl.dart';
import 'package:betgrid/model/driver_personal_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/driver_personal_data_creator.dart';
import '../../mock/data/firebase/mock_firebase_driver_personal_data_service.dart';
import '../../mock/data/mapper/mock_driver_personal_data_mapper.dart';

void main() {
  final firebaseDriverPersonalDataService =
      MockFirebaseDriverPersonalDataService();
  final driverPersonalDataMapper = MockDriverPersonalDataMapper();
  late DriverPersonalDataRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = DriverPersonalDataRepositoryImpl(
      firebaseDriverPersonalDataService,
      driverPersonalDataMapper,
    );
  });

  tearDown(() {
    reset(firebaseDriverPersonalDataService);
    reset(driverPersonalDataMapper);
  });

  group(
    'getDriverPersonalDataById, ',
    () {
      const String driverId = 'd1';
      const DriverPersonalDataCreator driverPersonalDataCreator =
          DriverPersonalDataCreator(
        id: driverId,
        name: 'Juan',
        surname: 'Pablo',
      );
      final List<DriverPersonalData> existingDriversPersonalData = [
        const DriverPersonalDataCreator(id: 'd2').createEntity(),
        const DriverPersonalDataCreator(id: 'd3').createEntity(),
      ];

      test(
        'should fetch driver personal data from db, add it to repo state and '
        'emit it if driver personal data does not exist in repo state',
        () async {
          final DriverPersonalDataDto expectedDriverPersonalDataDto =
              driverPersonalDataCreator.createDto();
          final DriverPersonalData expectedDriverPersonalData =
              driverPersonalDataCreator.createEntity();
          firebaseDriverPersonalDataService.mockFetchDriverPersonalDataById(
            expectedDriverPersonalDataDto: expectedDriverPersonalDataDto,
          );
          driverPersonalDataMapper.mockMapFromDto(
            expectedDriverPersonalData: expectedDriverPersonalData,
          );
          repositoryImpl.addEntities(existingDriversPersonalData);

          final Stream<DriverPersonalData?> driverPersonalData$ =
              repositoryImpl.getDriverPersonalDataById(driverId);

          expect(await driverPersonalData$.first, expectedDriverPersonalData);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingDriversPersonalData, expectedDriverPersonalData],
          );
          verify(
            () => firebaseDriverPersonalDataService.fetchDriverPersonalDataById(
              driverId,
            ),
          ).called(1);
        },
      );

      test(
        'should only emit driver personal data if it already exists in repo '
        'state',
        () async {
          final DriverPersonalData expectedDriverPersonalData =
              driverPersonalDataCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingDriversPersonalData, expectedDriverPersonalData],
          );

          final Stream<DriverPersonalData?> driverPersonalData$ =
              repositoryImpl.getDriverPersonalDataById(driverId);

          expect(await driverPersonalData$.first, expectedDriverPersonalData);
        },
      );
    },
  );
}
