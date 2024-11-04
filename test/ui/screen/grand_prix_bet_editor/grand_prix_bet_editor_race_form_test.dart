void main() {
  // test(
  //   'default state',
  //   () {
  //     const expectedDefaultState = GrandPrixBetEditorRaceForm(
  //       p1DriverId: null,
  //       p2DriverId: null,
  //       p3DriverId: null,
  //       p10DriverId: null,
  //       fastestLapDriverId: null,
  //       dnfDrivers: [],
  //       willBeSafetyCar: null,
  //       willBeRedFlag: null,
  //     );
  //
  //     const defaultState = GrandPrixBetEditorRaceForm();
  //
  //     expect(defaultState, expectedDefaultState);
  //   },
  // );
  //
  // group(
  //   'copyWith p1DriverId',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const String newValue = 'd1';
  //
  //         state = state.copyWith(p1DriverId: newValue);
  //
  //         expect(state.p1DriverId, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final String? currentValue = state.p1DriverId;
  //
  //         state = state.copyWith();
  //
  //         expect(state.p1DriverId, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(p1DriverId: null);
  //
  //         expect(state.p1DriverId, null);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith p1DriverId',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const String newValue = 'd1';
  //
  //         state = state.copyWith(p1DriverId: newValue);
  //
  //         expect(state.p1DriverId, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final String? currentValue = state.p1DriverId;
  //
  //         state = state.copyWith();
  //
  //         expect(state.p1DriverId, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(p1DriverId: null);
  //
  //         expect(state.p1DriverId, null);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith p3DriverId',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const String newValue = 'd1';
  //
  //         state = state.copyWith(p3DriverId: newValue);
  //
  //         expect(state.p3DriverId, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final String? currentValue = state.p3DriverId;
  //
  //         state = state.copyWith();
  //
  //         expect(state.p3DriverId, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(p3DriverId: null);
  //
  //         expect(state.p3DriverId, null);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith p10DriverId',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const String newValue = 'd1';
  //
  //         state = state.copyWith(p10DriverId: newValue);
  //
  //         expect(state.p10DriverId, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final String? currentValue = state.p10DriverId;
  //
  //         state = state.copyWith();
  //
  //         expect(state.p10DriverId, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(p10DriverId: null);
  //
  //         expect(state.p10DriverId, null);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith fastestLapDriverId',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const String newValue = 'd1';
  //
  //         state = state.copyWith(fastestLapDriverId: newValue);
  //
  //         expect(state.fastestLapDriverId, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final String? currentValue = state.fastestLapDriverId;
  //
  //         state = state.copyWith();
  //
  //         expect(state.fastestLapDriverId, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(fastestLapDriverId: null);
  //
  //         expect(state.fastestLapDriverId, null);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith dnfDrivers',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         final List<Driver> newValue = [
  //           const DriverCreator(id: 'd1').createEntity(),
  //         ];
  //
  //         state = state.copyWith(dnfDrivers: newValue);
  //
  //         expect(state.dnfDrivers, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final List<Driver> currentValue = state.dnfDrivers;
  //
  //         state = state.copyWith();
  //
  //         expect(state.dnfDrivers, currentValue);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith willBeSafetyCar',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const bool newValue = true;
  //
  //         state = state.copyWith(willBeSafetyCar: newValue);
  //
  //         expect(state.willBeSafetyCar, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final bool? currentValue = state.willBeSafetyCar;
  //
  //         state = state.copyWith();
  //
  //         expect(state.willBeSafetyCar, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(willBeSafetyCar: null);
  //
  //         expect(state.willBeSafetyCar, null);
  //       },
  //     );
  //   },
  // );
  //
  // group(
  //   'copyWith willBeRedFlag',
  //   () {
  //     GrandPrixBetEditorRaceForm state = const GrandPrixBetEditorRaceForm();
  //
  //     test(
  //       'should set new value if passed value is not null',
  //       () {
  //         const bool newValue = true;
  //
  //         state = state.copyWith(willBeRedFlag: newValue);
  //
  //         expect(state.willBeRedFlag, newValue);
  //       },
  //     );
  //
  //     test(
  //       'should not change current value if passed value is not specified',
  //       () {
  //         final bool? currentValue = state.willBeRedFlag;
  //
  //         state = state.copyWith();
  //
  //         expect(state.willBeRedFlag, currentValue);
  //       },
  //     );
  //
  //     test(
  //       'should set null if passed value is null',
  //       () {
  //         state = state.copyWith(willBeRedFlag: null);
  //
  //         expect(state.willBeRedFlag, null);
  //       },
  //     );
  //   },
  // );
}
