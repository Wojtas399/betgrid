import unittest
from service.race_points_service import RaceParams, calculate_points_for_race
from models.race_bet_points import RaceBetPoints

class RacePointsServiceTest(unittest.TestCase):
    def test_none_p1_bet(self):
        race_bets = RaceParams(
            p1_driver_id = None,
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 0,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 8,
            podium_and_p10_multiplier = None,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 2,
            total_points = 8 + 2 + (3 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_p2_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = None,
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 0,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 8,
            podium_and_p10_multiplier = None,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 2,
            total_points = 8 + 2 + (3 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_p3_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = None,
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 0,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 8,
            podium_and_p10_multiplier = None,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 2,
            total_points = 8 + 2 + (3 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_p10_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = None,
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 0,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 6,
            podium_and_p10_multiplier = None,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 2,
            total_points = 6 + 2 + (3 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_fastest_lap_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = None,
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 0,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + (3 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_dnf_drivers_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = None,
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 0,
            dnf_driver2_points = 0,
            dnf_driver3_points = 0,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 0,
            dnf_multiplier = None,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + 2 + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_dnf_driver_3_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 0,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 2,
            dnf_multiplier = None,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + 2 + 2 + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_dnf_driver_2_and_3_bets(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 0,
            dnf_driver3_points = 0,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 1,
            dnf_multiplier = None,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + 2 + 1 + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_dnf_driver_1_and_2_and_3_bets(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = [],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 0,
            dnf_driver2_points = 0,
            dnf_driver3_points = 0,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 0,
            dnf_multiplier = None,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + 2 + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_safety_car_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = None,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 0,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 1,
            total_points = (10 * 1.5) + 2 + (3 * 1.5) + 1
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_red_flag_bet(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = None,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 0,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 1,
            total_points = (10 * 1.5) + 2 + (3 * 1.5) + 1
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_none_p1_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = None,
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_p2_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = None,
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_p3_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = None,
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_p10_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = None,
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_fastest_lap_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = None,
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_dnf_drivers_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = None,
            is_safety_car = True,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_safety_car_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = None,
            is_red_flag = False,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_none_red_flag_result(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = None,
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, None)

    def test_full_points(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d16', 'd17', 'd18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + 2 + (3 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)
    
    def test_random_points_1(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd3',
            p3_driver_id = 'd2',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d20'],
            is_safety_car = False,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 0,
            p3_points = 0,
            p10_points = 4,
            fastest_lap_points = 2,
            dnf_driver1_points = 0,
            dnf_driver2_points = 0,
            dnf_driver3_points = 1,
            safety_car_points = 0,
            red_flag_points = 1,
            podium_and_p10_points = 6,
            podium_and_p10_multiplier = None,
            dnf_points = 1,
            dnf_multiplier = None,
            safety_car_and_red_flag_points = 1,
            total_points = 6 + 2 + 1 + 1
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_random_points_2(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = False,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd5',
            dnf_driver_ids = [],
            is_safety_car = False,
            is_red_flag = False,
        )
        expected_points = RaceBetPoints(
            p1_points = 2,
            p2_points = 2,
            p3_points = 2,
            p10_points = 4,
            fastest_lap_points = 0,
            dnf_driver1_points = 0,
            dnf_driver2_points = 0,
            dnf_driver3_points = 0,
            safety_car_points = 1,
            red_flag_points = 1,
            podium_and_p10_points = 10,
            podium_and_p10_multiplier = 1.5,
            dnf_points = 0,
            dnf_multiplier = None,
            safety_car_and_red_flag_points = 2,
            total_points = (10 * 1.5) + 2
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)

    def test_random_points_3(self):
        race_bets = RaceParams(
            p1_driver_id = 'd1',
            p2_driver_id = 'd2',
            p3_driver_id = 'd3',
            p10_driver_id = 'd10',
            fastest_lap_driver_id = 'd1',
            dnf_driver_ids = ['d18', 'd19', 'd20'],
            is_safety_car = True,
            is_red_flag = False,
        )
        race_results = RaceParams(
            p1_driver_id = 'd3',
            p2_driver_id = 'd1',
            p3_driver_id = 'd2',
            p10_driver_id = 'd11',
            fastest_lap_driver_id = 'd5',
            dnf_driver_ids = ['d20', 'd18', 'd19'],
            is_safety_car = False,
            is_red_flag = True,
        )
        expected_points = RaceBetPoints(
            p1_points = 0,
            p2_points = 0,
            p3_points = 0,
            p10_points = 0,
            fastest_lap_points = 0,
            dnf_driver1_points = 1,
            dnf_driver2_points = 1,
            dnf_driver3_points = 1,
            safety_car_points = 0,
            red_flag_points = 0,
            podium_and_p10_points = 0,
            podium_and_p10_multiplier = None,
            dnf_points = 3,
            dnf_multiplier = 1.5,
            safety_car_and_red_flag_points = 0,
            total_points = 3 * 1.5
        )

        points = calculate_points_for_race(race_bets, race_results)

        self.assertEqual(points, expected_points)
