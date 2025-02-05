import unittest
from functions.models.race_bet_points import RaceBetPoints
from functions.service.points.race_points_service import (
    RacePointsService,
    RaceParams,
)


class RacePointsServiceTest(unittest.TestCase):
    __P1_POINTS: float = 2.0
    __P2_POINTS: float = 2.0
    __P3_POINTS: float = 2.0
    __P10_POINTS: float = 4.0
    __FASTEST_LAP_POINTS: float = 2.0
    __ONE_DNF_POINTS: float = 2.0
    __SAFETY_CAR_POINTS: float = 1.0
    __RED_FLAG_POINTS: float = 1.0
    __PODIUM_P10_MULTIPLIER: float = 1.5
    __DNF_MULTIPLIER: float = 1.5

    def test_none_p1_bet(self):
        race_bets = RaceParams(
            p1_driver_id=None,
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        podium_and_p10_points = (
            self.__P2_POINTS +
            self.__P3_POINTS +
            self.__P10_POINTS
        )
        expected_points = RaceBetPoints(
            p1_points=0,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=podium_and_p10_points,
            podium_and_p10_multiplier=None,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                podium_and_p10_points +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_p2_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id=None,
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        podium_and_p10_points = (
            self.__P1_POINTS +
            self.__P3_POINTS +
            self.__P10_POINTS
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=0,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=podium_and_p10_points,
            podium_and_p10_multiplier=None,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                podium_and_p10_points +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_p3_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id=None,
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        podium_and_p10_points = (
            self.__P1_POINTS +
            self.__P2_POINTS +
            self.__P10_POINTS
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=0,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=podium_and_p10_points,
            podium_and_p10_multiplier=None,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                podium_and_p10_points +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_p10_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id=None,
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        podium_and_p10_points = (
            self.__P1_POINTS +
            self.__P2_POINTS +
            self.__P3_POINTS
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=0,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=podium_and_p10_points,
            podium_and_p10_multiplier=None,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                podium_and_p10_points +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_fastest_lap_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id=None,
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=0,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__full_dnf_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_dnf_drivers_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=None,
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=0,
            dnf_driver2_points=0,
            dnf_driver3_points=0,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=0,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=self.__full_safety_car_red_flag_points,
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_dnf_driver_3_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', None],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=0,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=4,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                4 +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_dnf_driver_2_and_3_bets(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', None, None],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=0,
            dnf_driver3_points=0,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=2,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                2 +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_dnf_driver_1_and_2_and_3_bets(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=[None, None, None],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=0,
            dnf_driver2_points=0,
            dnf_driver3_points=0,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=0,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_safety_car_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=None,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=0,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=self.__RED_FLAG_POINTS,
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__RED_FLAG_POINTS
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_red_flag_bet(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=None,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=0,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=self.__SAFETY_CAR_POINTS,
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__SAFETY_CAR_POINTS
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_p1_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id=None,
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_p2_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id=None,
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_p3_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id=None,
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_p10_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id=None,
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_fastest_lap_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id=None,
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_dnf_drivers_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=None,
            is_safety_car=True,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_safety_car_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=None,
            is_red_flag=False,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_none_red_flag_result(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=None,
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_full_points(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__FASTEST_LAP_POINTS +
                self.__full_dnf_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_random_points_1(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d3',
            p3_driver_id='d2',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d20'],
            is_safety_car=False,
            is_red_flag=False,
        )
        podium_p10_points = self.__P1_POINTS + self.__P10_POINTS
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=0,
            p3_points=0,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=self.__FASTEST_LAP_POINTS,
            dnf_driver1_points=0,
            dnf_driver2_points=0,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=0,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=podium_p10_points,
            podium_and_p10_multiplier=None,
            dnf_points=self.__ONE_DNF_POINTS,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=1,
            total_points=(
                podium_p10_points +
                self.__FASTEST_LAP_POINTS +
                self.__ONE_DNF_POINTS +
                self.__RED_FLAG_POINTS
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_random_points_2(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=False,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d5',
            dnf_driver_ids=[],
            is_safety_car=False,
            is_red_flag=False,
        )
        expected_points = RaceBetPoints(
            p1_points=self.__P1_POINTS,
            p2_points=self.__P2_POINTS,
            p3_points=self.__P3_POINTS,
            p10_points=self.__P10_POINTS,
            fastest_lap_points=0,
            dnf_driver1_points=0,
            dnf_driver2_points=0,
            dnf_driver3_points=0,
            safety_car_points=self.__SAFETY_CAR_POINTS,
            red_flag_points=self.__RED_FLAG_POINTS,
            podium_and_p10_points=self.__full_podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=0,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=(
                self.__full_safety_car_red_flag_points
            ),
            total_points=(
                self.__full_podium_and_p10_points_included_multiplier +
                self.__full_safety_car_red_flag_points
            )
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_random_points_3(self):
        race_bets = RaceParams(
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            is_safety_car=True,
            is_red_flag=False,
        )
        race_results = RaceParams(
            p1_driver_id='d3',
            p2_driver_id='d1',
            p3_driver_id='d2',
            p10_driver_id='d11',
            fastest_lap_driver_id='d5',
            dnf_driver_ids=['d20', 'd18', 'd19'],
            is_safety_car=False,
            is_red_flag=True,
        )
        expected_points = RaceBetPoints(
            p1_points=0,
            p2_points=0,
            p3_points=0,
            p10_points=0,
            fastest_lap_points=0,
            dnf_driver1_points=self.__ONE_DNF_POINTS,
            dnf_driver2_points=self.__ONE_DNF_POINTS,
            dnf_driver3_points=self.__ONE_DNF_POINTS,
            safety_car_points=0,
            red_flag_points=0,
            podium_and_p10_points=0,
            podium_and_p10_multiplier=None,
            dnf_points=self.__full_dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=0,
            total_points=self.__full_dnf_points_included_multiplier
        )

        points = RacePointsService(
            race_bets=race_bets,
            race_results=race_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    @property
    def __full_podium_and_p10_points(self) -> float:
        return (
            self.__P1_POINTS +
            self.__P2_POINTS +
            self.__P3_POINTS +
            self.__P10_POINTS
        )

    @property
    def __full_dnf_points(self) -> float:
        return 3 * self.__ONE_DNF_POINTS

    @property
    def __full_safety_car_red_flag_points(self):
        return self.__SAFETY_CAR_POINTS + self.__RED_FLAG_POINTS

    @property
    def __full_podium_and_p10_points_included_multiplier(self) -> float:
        return self.__full_podium_and_p10_points * self.__PODIUM_P10_MULTIPLIER

    @property
    def __full_dnf_points_included_multiplier(self) -> float:
        return self.__full_dnf_points * self.__DNF_MULTIPLIER
