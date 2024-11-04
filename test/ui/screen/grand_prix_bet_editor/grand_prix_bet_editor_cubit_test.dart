void main() {
  // final authRepository = MockAuthRepository();
  // final grandPrixBetRepository = MockGrandPrixBetRepository();
  // final driverRepository = MockDriverRepository();
  // const String grandPrixId = 'gp1';
  //
  // GrandPrixBetEditorCubit createCubit() => GrandPrixBetEditorCubit(
  //       authRepository,
  //       grandPrixBetRepository,
  //       driverRepository,
  //     );
  //
  // tearDown(() {
  //   reset(authRepository);
  //   reset(grandPrixBetRepository);
  //   reset(driverRepository);
  // });
  //
  // group(
  //   'initialize',
  //   () {
  //     const String loggedUserId = 'u1';
  //     final List<Driver> allDrivers = [
  //       const DriverCreator(
  //         id: 'd1',
  //         team: DriverCreatorTeam.mercedes,
  //         surname: 'Russel',
  //       ).createEntity(),
  //       const DriverCreator(
  //         id: 'd2',
  //         team: DriverCreatorTeam.alpine,
  //       ).createEntity(),
  //       const DriverCreator(
  //         id: 'd3',
  //         team: DriverCreatorTeam.mercedes,
  //         surname: 'Hamilton',
  //       ).createEntity(),
  //     ];
  //     final bet = GrandPrixBetCreator(
  //       qualiStandingsByDriverIds: List.generate(
  //         20,
  //         (int driverIndex) => 'd${driverIndex + 1}',
  //       ),
  //       p1DriverId: 'd1',
  //       p2DriverId: 'd2',
  //       p3DriverId: 'd3',
  //       p10DriverId: 'd10',
  //       fastestLapDriverId: 'd1',
  //       dnfDriverIds: ['d1'],
  //       willBeSafetyCar: true,
  //       willBeRedFlag: false,
  //     ).createEntity();
  //     final updatedBet = GrandPrixBetCreator(
  //       qualiStandingsByDriverIds: List.generate(
  //         20,
  //         (int driverIndex) => 'd${driverIndex + 1}',
  //       ),
  //       p1DriverId: 'd1',
  //       p2DriverId: 'd2',
  //       p3DriverId: 'd3',
  //       p10DriverId: 'd10',
  //       fastestLapDriverId: 'd1',
  //       dnfDriverIds: ['d1', 'd2'],
  //       willBeSafetyCar: true,
  //       willBeRedFlag: false,
  //     ).createEntity();
  //     final bet$ = StreamController<GrandPrixBet>()..add(bet);
  //     GrandPrixBetEditorState? state;
  //
  //     blocTest(
  //       'should load all drivers, should listen to grand prix bet and should '
  //       'emit existing bets and all drivers sorted by team and surname',
  //       build: () => createCubit(),
  //       setUp: () {
  //         driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
  //         authRepository.mockGetLoggedUserId(loggedUserId);
  //         when(
  //           () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
  //             playerId: loggedUserId,
  //             grandPrixId: grandPrixId,
  //           ),
  //         ).thenAnswer((_) => bet$.stream);
  //       },
  //       act: (cubit) async {
  //         await cubit.initialize(
  //           grandPrixId: grandPrixId,
  //         );
  //         bet$.add(updatedBet);
  //       },
  //       expect: () => [
  //         state = GrandPrixBetEditorState(
  //           status: GrandPrixBetEditorStateStatus.completed,
  //           allDrivers: [
  //             allDrivers[1],
  //             allDrivers.last,
  //             allDrivers.first,
  //           ],
  //           originalGrandPrixBet: bet,
  //           qualiStandingsByDriverIds: bet.qualiStandingsByDriverIds,
  //           raceForm: GrandPrixBetEditorRaceForm(
  //             p1DriverId: bet.p1DriverId,
  //             p2DriverId: bet.p2DriverId,
  //             p3DriverId: bet.p3DriverId,
  //             p10DriverId: bet.p10DriverId,
  //             fastestLapDriverId: bet.fastestLapDriverId,
  //             dnfDrivers: [
  //               allDrivers.first,
  //             ],
  //             willBeSafetyCar: bet.willBeSafetyCar,
  //             willBeRedFlag: bet.willBeRedFlag,
  //           ),
  //         ),
  //         state = state!.copyWith(
  //           originalGrandPrixBet: updatedBet,
  //           raceForm: state!.raceForm.copyWith(
  //             dnfDrivers: [
  //               allDrivers.first,
  //               allDrivers[1],
  //             ],
  //           ),
  //         ),
  //       ],
  //       verify: (_) {
  //         verify(driverRepository.getAllDrivers).called(1);
  //         verify(() => authRepository.loggedUserId$).called(1);
  //         verify(
  //           () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
  //             playerId: loggedUserId,
  //             grandPrixId: grandPrixId,
  //           ),
  //         ).called(1);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'onQualiStandingsChanged',
  //   () {
  //     const String driverId = 'd1';
  //
  //     blocTest(
  //       'should set driverId at standing - 1 position in '
  //       'qualiStandingsByDriverIds',
  //       build: () => createCubit(),
  //       act: (cubit) => cubit.onQualiStandingsChanged(
  //         standing: 10,
  //         driverId: driverId,
  //       ),
  //       expect: () => [
  //         GrandPrixBetEditorState(
  //           status: GrandPrixBetEditorStateStatus.completed,
  //           qualiStandingsByDriverIds: List.generate(
  //             20,
  //             (int standingIndex) => standingIndex == 9 ? driverId : null,
  //           ),
  //         ),
  //       ],
  //     );
  //
  //     blocTest(
  //       'should set null at index where the value is the same as driverId and '
  //       'then should set driverId at standing - 1 position',
  //       build: () => createCubit(),
  //       seed: () => GrandPrixBetEditorState(
  //         qualiStandingsByDriverIds: List.generate(
  //           20,
  //           (int standingIndex) => standingIndex == 3 ? driverId : null,
  //         ),
  //       ),
  //       act: (cubit) =>
  //           cubit.onQualiStandingsChanged(standing: 8, driverId: driverId),
  //       expect: () => [
  //         GrandPrixBetEditorState(
  //           status: GrandPrixBetEditorStateStatus.completed,
  //           qualiStandingsByDriverIds: List.generate(
  //             20,
  //             (int standingIndex) => standingIndex == 7 ? driverId : null,
  //           ),
  //         ),
  //       ],
  //     );
  //   },
  // );
  //
  // blocTest(
  //   'onRaceP1DriverChanged, '
  //   'should assign passed driverId to p1DriverId in raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onRaceP1DriverChanged('d1'),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         p1DriverId: 'd1',
  //       ),
  //     ),
  //   ],
  // );
  //
  // blocTest(
  //   'onRaceP2DriverChanged, '
  //   'should assign passed driverId to p2DriverId in raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onRaceP2DriverChanged('d1'),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         p2DriverId: 'd1',
  //       ),
  //     ),
  //   ],
  // );
  //
  // blocTest(
  //   'onRaceP3DriverChanged, '
  //   'should assign passed driverId to p3DriverId in raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onRaceP3DriverChanged('d1'),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         p3DriverId: 'd1',
  //       ),
  //     ),
  //   ],
  // );
  //
  // blocTest(
  //   'onRaceP10DriverChanged, '
  //   'should assign passed driverId to p10DriverId in raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onRaceP10DriverChanged('d1'),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         p10DriverId: 'd1',
  //       ),
  //     ),
  //   ],
  // );
  //
  // blocTest(
  //   'onRaceFastestLapDriverChanged, '
  //   'should assign passed driverId to fastestLapDriverId in raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onRaceFastestLapDriverChanged('d1'),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         fastestLapDriverId: 'd1',
  //       ),
  //     ),
  //   ],
  // );
  //
  // group(
  //   'onDnfDriverSelected',
  //   () {
  //     const String driverId = 'd1';
  //     final List<Driver> allDrivers = [
  //       const DriverCreator(id: driverId).createEntity(),
  //       const DriverCreator(id: 'd2').createEntity(),
  //     ];
  //     GrandPrixBetEditorState? state;
  //
  //     blocTest(
  //       'should do nothing if allDrivers list is empty',
  //       build: () => createCubit(),
  //       seed: () => const GrandPrixBetEditorState(
  //         allDrivers: [],
  //       ),
  //       act: (cubit) => cubit.onDnfDriverSelected(driverId),
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should do nothing if driver_personal_data with matching id does not exist in '
  //       'allDrivers list',
  //       build: () => createCubit(),
  //       seed: () => GrandPrixBetEditorState(
  //         status: GrandPrixBetEditorStateStatus.completed,
  //         allDrivers: allDrivers,
  //       ),
  //       act: (cubit) => cubit.onDnfDriverSelected('d3'),
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should do nothing if driver_personal_data with matching id already exists in '
  //       'dnfDrivers list of raceForm',
  //       build: () => createCubit(),
  //       seed: () => GrandPrixBetEditorState(
  //         allDrivers: allDrivers,
  //         originalGrandPrixBet: GrandPrixBetCreator(
  //           dnfDriverIds: [driverId, 'd2'],
  //         ).createEntity(),
  //         raceForm: GrandPrixBetEditorRaceForm(
  //           dnfDrivers: allDrivers,
  //         ),
  //       ),
  //       act: (cubit) => cubit.onDnfDriverSelected(driverId),
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should add driver_personal_data to dnfDrivers list of raceForm if driver_personal_data with '
  //       'matching id does not exist in this list',
  //       build: () => createCubit(),
  //       seed: () => state = GrandPrixBetEditorState(
  //         allDrivers: allDrivers,
  //         originalGrandPrixBet: GrandPrixBetCreator(
  //           dnfDriverIds: ['d2'],
  //         ).createEntity(),
  //         raceForm: GrandPrixBetEditorRaceForm(
  //           dnfDrivers: [allDrivers.last],
  //         ),
  //       ),
  //       act: (cubit) => cubit.onDnfDriverSelected(driverId),
  //       expect: () => [
  //         state = state!.copyWith(
  //           raceForm: state!.raceForm.copyWith(
  //             dnfDrivers: [allDrivers.last, allDrivers.first],
  //           ),
  //         ),
  //       ],
  //     );
  //   },
  // );
  //
  // group(
  //   'onDnfDriverRemoved',
  //   () {
  //     const String driverId = 'd1';
  //     final List<Driver> allDrivers = [
  //       const DriverCreator(id: driverId).createEntity(),
  //       const DriverCreator(id: 'd2').createEntity(),
  //     ];
  //     GrandPrixBetEditorState? state;
  //
  //     blocTest(
  //       'should do nothing if allDrivers list is empty',
  //       build: () => createCubit(),
  //       seed: () => const GrandPrixBetEditorState(
  //         allDrivers: [],
  //       ),
  //       act: (cubit) => cubit.onDnfDriverRemoved(driverId),
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should do nothing if driver_personal_data with matching id does not exist in '
  //       'dnfDrivers list of raceForm',
  //       build: () => createCubit(),
  //       seed: () => state = GrandPrixBetEditorState(
  //         allDrivers: allDrivers,
  //         originalGrandPrixBet: GrandPrixBetCreator(
  //           dnfDriverIds: ['d2'],
  //         ).createEntity(),
  //         raceForm: GrandPrixBetEditorRaceForm(
  //           dnfDrivers: [allDrivers.last],
  //         ),
  //       ),
  //       act: (cubit) => cubit.onDnfDriverRemoved(driverId),
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should remove driver_personal_data from dnfDrivers list of raceForm if driver_personal_data with '
  //       'matching id exists in this list',
  //       build: () => createCubit(),
  //       seed: () => state = GrandPrixBetEditorState(
  //         allDrivers: allDrivers,
  //         originalGrandPrixBet: GrandPrixBetCreator(
  //           dnfDriverIds: ['d2', driverId],
  //         ).createEntity(),
  //         raceForm: GrandPrixBetEditorRaceForm(
  //           dnfDrivers: [allDrivers.last, allDrivers.first],
  //         ),
  //       ),
  //       act: (cubit) => cubit.onDnfDriverRemoved(driverId),
  //       expect: () => [
  //         state = state!.copyWith(
  //           raceForm: state!.raceForm.copyWith(
  //             dnfDrivers: [allDrivers.last],
  //           ),
  //         ),
  //       ],
  //     );
  //   },
  // );
  //
  // blocTest(
  //   'onSafetyCarPredictionChanged, '
  //   'should assign passed willBeSafetyCar to willBeSafetyCar of raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onSafetyCarPredictionChanged(false),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         willBeSafetyCar: false,
  //       ),
  //     ),
  //   ],
  // );
  //
  // blocTest(
  //   'onRedFlagPredictionChanged, '
  //   'should assign passed willBeRedFlag to willBeRedFlag of raceForm',
  //   build: () => createCubit(),
  //   act: (cubit) => cubit.onRedFlagPredictionChanged(false),
  //   expect: () => [
  //     const GrandPrixBetEditorState(
  //       status: GrandPrixBetEditorStateStatus.completed,
  //       raceForm: GrandPrixBetEditorRaceForm(
  //         willBeRedFlag: false,
  //       ),
  //     ),
  //   ],
  // );
  //
  // group(
  //   'submit',
  //   () {
  //     const String loggedUserId = 'u1';
  //     const String grandPrixBetId = 'gpb1';
  //     final List<String?> qualiStandingsByDriverIds = List.generate(
  //       20,
  //       (int index) => switch (index) {
  //         0 => 'd1',
  //         9 => 'd10',
  //         _ => null,
  //       },
  //     );
  //     const String p1DriverId = 'd1';
  //     const String p2DriverId = 'd2';
  //     const String p3DriverId = 'd3';
  //     const String p10DriverId = 'd10';
  //     const String fastestLapDriverId = 'd1';
  //     const List<String> dnfDriverIds = ['d1', 'd2'];
  //     const bool willBeSafetyCar = false;
  //     const bool willBeRedFlag = true;
  //     final List<Driver> allDrivers = [
  //       const DriverCreator(id: 'd1').createEntity(),
  //       const DriverCreator(id: 'd2').createEntity(),
  //       const DriverCreator(id: 'd3').createEntity(),
  //       const DriverCreator(id: 'd10').createEntity(),
  //     ];
  //     GrandPrixBetEditorState? state;
  //
  //     blocTest(
  //       'should do nothing if cubit has not been initialized with grand prix id',
  //       build: () => createCubit(),
  //       act: (cubit) async => await cubit.submit(),
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should finish method call if logged user does not exist',
  //       build: () => createCubit(),
  //       setUp: () {
  //         driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
  //         authRepository.mockGetLoggedUserId(null);
  //       },
  //       act: (cubit) async {
  //         await cubit.initialize(grandPrixId: grandPrixId);
  //         await cubit.submit();
  //       },
  //       expect: () => [],
  //     );
  //
  //     blocTest(
  //       'should call addGrandPrixBet method from GrandPrixBetRepository if bet '
  //       'does not exist in GrandPrixBetRepository',
  //       build: () => createCubit(),
  //       setUp: () {
  //         driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
  //         authRepository.mockGetLoggedUserId(loggedUserId);
  //         grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix();
  //         grandPrixBetRepository.mockAddGrandPrixBet();
  //       },
  //       seed: () => state = GrandPrixBetEditorState(
  //         qualiStandingsByDriverIds: qualiStandingsByDriverIds,
  //         raceForm: GrandPrixBetEditorRaceForm(
  //           p1DriverId: p1DriverId,
  //           p2DriverId: p2DriverId,
  //           p3DriverId: p3DriverId,
  //           p10DriverId: p10DriverId,
  //           fastestLapDriverId: fastestLapDriverId,
  //           dnfDrivers: [allDrivers.first, allDrivers[1]],
  //           willBeSafetyCar: willBeSafetyCar,
  //           willBeRedFlag: willBeRedFlag,
  //         ),
  //       ),
  //       act: (cubit) async {
  //         await cubit.initialize(grandPrixId: grandPrixId);
  //         await cubit.stream.first;
  //         await cubit.submit();
  //       },
  //       expect: () => [
  //         state = state!.copyWith(
  //           status: GrandPrixBetEditorStateStatus.completed,
  //           allDrivers: allDrivers,
  //         ),
  //         state = state!.copyWith(
  //           status: GrandPrixBetEditorStateStatus.saving,
  //         ),
  //         state = state!.copyWith(
  //           status: GrandPrixBetEditorStateStatus.successfullySaved,
  //         ),
  //       ],
  //       verify: (_) => verify(
  //         () => grandPrixBetRepository.addGrandPrixBet(
  //           playerId: loggedUserId,
  //           grandPrixId: grandPrixId,
  //           qualiStandingsByDriverIds: qualiStandingsByDriverIds,
  //           p1DriverId: p1DriverId,
  //           p2DriverId: p2DriverId,
  //           p3DriverId: p3DriverId,
  //           p10DriverId: p10DriverId,
  //           fastestLapDriverId: fastestLapDriverId,
  //           dnfDriverIds: dnfDriverIds,
  //           willBeSafetyCar: willBeSafetyCar,
  //           willBeRedFlag: willBeRedFlag,
  //         ),
  //       ).called(1),
  //     );
  //
  //     blocTest(
  //       'should call updateGrandPrixBet method from GrandPrixBetRepository if '
  //       'bet exists in GrandPrixBetRepository',
  //       build: () => createCubit(),
  //       setUp: () {
  //         driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
  //         authRepository.mockGetLoggedUserId(loggedUserId);
  //         grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix();
  //         grandPrixBetRepository.mockUpdateGrandPrixBet();
  //       },
  //       seed: () => state = GrandPrixBetEditorState(
  //         qualiStandingsByDriverIds: qualiStandingsByDriverIds,
  //         originalGrandPrixBet: GrandPrixBetCreator(
  //           id: grandPrixBetId,
  //         ).createEntity(),
  //         raceForm: GrandPrixBetEditorRaceForm(
  //           p1DriverId: p1DriverId,
  //           p2DriverId: p2DriverId,
  //           p3DriverId: p3DriverId,
  //           p10DriverId: p10DriverId,
  //           fastestLapDriverId: fastestLapDriverId,
  //           dnfDrivers: [allDrivers.first, allDrivers[1]],
  //           willBeSafetyCar: willBeSafetyCar,
  //           willBeRedFlag: willBeRedFlag,
  //         ),
  //       ),
  //       act: (cubit) async {
  //         await cubit.initialize(grandPrixId: grandPrixId);
  //         await cubit.stream.first;
  //         await cubit.submit();
  //       },
  //       expect: () => [
  //         state = state!.copyWith(
  //           status: GrandPrixBetEditorStateStatus.completed,
  //           allDrivers: allDrivers,
  //         ),
  //         state = state!.copyWith(
  //           status: GrandPrixBetEditorStateStatus.saving,
  //         ),
  //         state = state!.copyWith(
  //           status: GrandPrixBetEditorStateStatus.successfullySaved,
  //         ),
  //       ],
  //       verify: (_) => verify(
  //         () => grandPrixBetRepository.updateGrandPrixBet(
  //           playerId: loggedUserId,
  //           grandPrixBetId: grandPrixBetId,
  //           qualiStandingsByDriverIds: qualiStandingsByDriverIds,
  //           p1DriverId: p1DriverId,
  //           p2DriverId: p2DriverId,
  //           p3DriverId: p3DriverId,
  //           p10DriverId: p10DriverId,
  //           fastestLapDriverId: fastestLapDriverId,
  //           dnfDriverIds: dnfDriverIds,
  //           willBeSafetyCar: willBeSafetyCar,
  //           willBeRedFlag: willBeRedFlag,
  //         ),
  //       ).called(1),
  //     );
  //   },
  // );
}
