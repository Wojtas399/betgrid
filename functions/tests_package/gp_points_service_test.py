import unittest
from functions.service.points import calculate_points_for_gp
from functions.models import (
    GrandPrixBets,
    GrandPrixResults,
    GrandPrixBetPoints,
    QualiBetPoints,
    RaceBetPoints,
)


class GpPointsServiceTest(unittest.TestCase):
    def test_none_quali_bets(self):
        gp_bets = GrandPrixBets(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=None,
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            fastest_lap_driver_id='d1',
            p10_driver_id='d10',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            will_be_safety_car=False,
            will_be_red_flag=False,
        )
        gp_results = GrandPrixResults(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            was_there_safety_car=False,
            was_there_red_flag=False,
        )
        quali_bet_points = QualiBetPoints(
            q3_p1_points=0,
            q3_p2_points=0,
            q3_p3_points=0,
            q3_p4_points=0,
            q3_p5_points=0,
            q3_p6_points=0,
            q3_p7_points=0,
            q3_p8_points=0,
            q3_p9_points=0,
            q3_p10_points=0,
            q2_p11_points=0,
            q2_p12_points=0,
            q2_p13_points=0,
            q2_p14_points=0,
            q2_p15_points=0,
            q1_p16_points=0,
            q1_p17_points=0,
            q1_p18_points=0,
            q1_p19_points=0,
            q1_p20_points=0,
            q3_points=0,
            q2_points=0,
            q1_points=0,
            q3_multiplier=None,
            q2_multiplier=None,
            q1_multiplier=None,
            total_points=0,
            multiplier=None,
        )
        race_bet_points = RaceBetPoints(
            p1_points=2,
            p2_points=2,
            p3_points=2,
            p10_points=4,
            fastest_lap_points=2,
            dnf_driver1_points=1,
            dnf_driver2_points=1,
            dnf_driver3_points=1,
            safety_car_points=1,
            red_flag_points=1,
            podium_and_p10_points=10,
            podium_and_p10_multiplier=1.5,
            dnf_points=3,
            dnf_multiplier=1.5,
            safety_car_and_red_flag_points=2,
            total_points=(10 * 1.5) + 2 + (3 * 1.5) + 2,
        )
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=race_bet_points,
            total_points=quali_bet_points.total_points + race_bet_points.total_points,
        )

        gp_points = calculate_points_for_gp(gp_bets, gp_results)

        self.assertEqual(gp_points, expected_gp_points)

    def test_none_race_bets(self):
        gp_bets = GrandPrixBets(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id=None,
            p2_driver_id=None,
            p3_driver_id=None,
            p10_driver_id=None,
            fastest_lap_driver_id=None,
            dnf_driver_ids=None,
            will_be_safety_car=None,
            will_be_red_flag=None,
        )
        gp_results = GrandPrixResults(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            was_there_safety_car=False,
            was_there_red_flag=False,
        )
        quali_bet_points = QualiBetPoints(
            q3_p1_points=1,
            q3_p2_points=1,
            q3_p3_points=1,
            q3_p4_points=2,
            q3_p5_points=2,
            q3_p6_points=2,
            q3_p7_points=2,
            q3_p8_points=2,
            q3_p9_points=2,
            q3_p10_points=2,
            q2_p11_points=2,
            q2_p12_points=2,
            q2_p13_points=2,
            q2_p14_points=2,
            q2_p15_points=2,
            q1_p16_points=1,
            q1_p17_points=1,
            q1_p18_points=1,
            q1_p19_points=1,
            q1_p20_points=1,
            q3_points=17,
            q2_points=10,
            q1_points=5,
            q3_multiplier=1.75,
            q2_multiplier=1.5,
            q1_multiplier=1.25,
            total_points=(17 + 10 + 5) * (1.75 + 1.5 + 1.25),
            multiplier=1.75 + 1.5 + 1.25,
        )
        race_bet_points = RaceBetPoints(
            p1_points=0,
            p2_points=0,
            p3_points=0,
            p10_points=0,
            fastest_lap_points=0,
            dnf_driver1_points=0,
            dnf_driver2_points=0,
            dnf_driver3_points=0,
            safety_car_points=0,
            red_flag_points=0,
            podium_and_p10_points=0,
            podium_and_p10_multiplier=None,
            dnf_points=0,
            dnf_multiplier=None,
            safety_car_and_red_flag_points=0,
            total_points=0,
        )
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=race_bet_points,
            total_points=quali_bet_points.total_points + race_bet_points.total_points,
        )

        gp_points = calculate_points_for_gp(gp_bets, gp_results)

        self.assertEqual(gp_points, expected_gp_points)

    def test_none_quali_results(self):
        gp_bets = GrandPrixBets(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            will_be_safety_car=False,
            will_be_red_flag=False,
        )
        gp_results = GrandPrixResults(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=None,
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            was_there_safety_car=False,
            was_there_red_flag=False,
        )
        race_bet_points = RaceBetPoints(
            p1_points=2,
            p2_points=2,
            p3_points=2,
            p10_points=4,
            fastest_lap_points=2,
            dnf_driver1_points=1,
            dnf_driver2_points=1,
            dnf_driver3_points=1,
            safety_car_points=1,
            red_flag_points=1,
            podium_and_p10_points=10,
            podium_and_p10_multiplier=1.5,
            dnf_points=3,
            dnf_multiplier=1.5,
            safety_car_and_red_flag_points=2,
            total_points=(10 * 1.5) + 2 + (3 * 1.5) + 2,
        )
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=None,
            race_bet_points=race_bet_points,
            total_points=race_bet_points.total_points,
        )

        gp_points = calculate_points_for_gp(gp_bets, gp_results)

        self.assertEqual(gp_points, expected_gp_points)

    def test_none_race_results(self):
        gp_bets = GrandPrixBets(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            will_be_safety_car=False,
            will_be_red_flag=False,
        )
        gp_results = GrandPrixResults(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id=None,
            p2_driver_id=None,
            p3_driver_id=None,
            p10_driver_id=None,
            fastest_lap_driver_id=None,
            dnf_driver_ids=None,
            was_there_safety_car=None,
            was_there_red_flag=None,
        )
        quali_bet_points = QualiBetPoints(
            q3_p1_points=1,
            q3_p2_points=1,
            q3_p3_points=1,
            q3_p4_points=2,
            q3_p5_points=2,
            q3_p6_points=2,
            q3_p7_points=2,
            q3_p8_points=2,
            q3_p9_points=2,
            q3_p10_points=2,
            q2_p11_points=2,
            q2_p12_points=2,
            q2_p13_points=2,
            q2_p14_points=2,
            q2_p15_points=2,
            q1_p16_points=1,
            q1_p17_points=1,
            q1_p18_points=1,
            q1_p19_points=1,
            q1_p20_points=1,
            q3_points=17,
            q2_points=10,
            q1_points=5,
            q3_multiplier=1.75,
            q2_multiplier=1.5,
            q1_multiplier=1.25,
            total_points=(17 + 10 + 5) * (1.75 + 1.5 + 1.25),
            multiplier=1.75 + 1.5 + 1.25,
        )
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=None,
            total_points=quali_bet_points.total_points,
        )

        gp_points = calculate_points_for_gp(gp_bets, gp_results)

        self.assertEqual(gp_points, expected_gp_points)

    def test_full_points(self):
        gp_bets = GrandPrixBets(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            will_be_safety_car=False,
            will_be_red_flag=False,
        )
        gp_results = GrandPrixResults(
            season_grand_prix_id='gp1',
            quali_standings_by_driver_ids=[
                'd1',
                'd2',
                'd3',
                'd4',
                'd5',
                'd6',
                'd7',
                'd8',
                'd9',
                'd10',
                'd11',
                'd12',
                'd13',
                'd14',
                'd15',
                'd16',
                'd17',
                'd18',
                'd19',
                'd20',
            ],
            p1_driver_id='d1',
            p2_driver_id='d2',
            p3_driver_id='d3',
            p10_driver_id='d10',
            fastest_lap_driver_id='d1',
            dnf_driver_ids=['d18', 'd19', 'd20'],
            was_there_safety_car=False,
            was_there_red_flag=False,
        )
        quali_bet_points = QualiBetPoints(
            q3_p1_points=1,
            q3_p2_points=1,
            q3_p3_points=1,
            q3_p4_points=2,
            q3_p5_points=2,
            q3_p6_points=2,
            q3_p7_points=2,
            q3_p8_points=2,
            q3_p9_points=2,
            q3_p10_points=2,
            q2_p11_points=2,
            q2_p12_points=2,
            q2_p13_points=2,
            q2_p14_points=2,
            q2_p15_points=2,
            q1_p16_points=1,
            q1_p17_points=1,
            q1_p18_points=1,
            q1_p19_points=1,
            q1_p20_points=1,
            q3_points=17,
            q2_points=10,
            q1_points=5,
            q3_multiplier=1.75,
            q2_multiplier=1.5,
            q1_multiplier=1.25,
            total_points=(17 + 10 + 5) * (1.75 + 1.5 + 1.25),
            multiplier=1.75 + 1.5 + 1.25,
        )
        race_bet_points = RaceBetPoints(
            p1_points=2,
            p2_points=2,
            p3_points=2,
            p10_points=4,
            fastest_lap_points=2,
            dnf_driver1_points=1,
            dnf_driver2_points=1,
            dnf_driver3_points=1,
            safety_car_points=1,
            red_flag_points=1,
            podium_and_p10_points=10,
            podium_and_p10_multiplier=1.5,
            dnf_points=3,
            dnf_multiplier=1.5,
            safety_car_and_red_flag_points=2,
            total_points=(10 * 1.5) + 2 + (3 * 1.5) + 2,
        )
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=race_bet_points,
            total_points=quali_bet_points.total_points + race_bet_points.total_points,
        )

        gp_points = calculate_points_for_gp(gp_bets, gp_results)

        self.assertEqual(gp_points, expected_gp_points)
