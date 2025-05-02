import unittest
from models import (
    GrandPrixBets,
    GrandPrixResults,
    GrandPrixBetPoints,
    QualiBetPoints,
    RaceBetPoints,
)
from service.points import GpPointsService


class GpPointsServiceTest(unittest.TestCase):
    __Q1_POINTS: float = 1.0
    __Q2_POINTS: float = 2.0
    __Q3_P1_TO_P3_POINTS: float = 1.0
    __Q3_P4_TO_P10_POINTS: float = 2.0
    __Q1_MULTIPLIER: float = 1.25
    __Q2_MULTIPLIER: float = 1.5
    __Q3_MULTIPLIER: float = 1.75
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
        race_bet_points = self.__race_full_points
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=race_bet_points,
            total_points=quali_bet_points.total_points + race_bet_points.total_points,
        )

        gp_points = GpPointsService(
            gp_bets=gp_bets,
            gp_results=gp_results
        ).calculate_points()

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
        quali_bet_points = self.__quali_full_points
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

        gp_points = GpPointsService(
            gp_bets=gp_bets,
            gp_results=gp_results
        ).calculate_points()

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
        race_bet_points = self.__race_full_points
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=None,
            race_bet_points=race_bet_points,
            total_points=race_bet_points.total_points,
        )

        gp_points = GpPointsService(
            gp_bets=gp_bets,
            gp_results=gp_results
        ).calculate_points()

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
        quali_bet_points = self.__quali_full_points
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=None,
            total_points=quali_bet_points.total_points,
        )

        gp_points = GpPointsService(
            gp_bets=gp_bets,
            gp_results=gp_results
        ).calculate_points()

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
        quali_bet_points = self.__quali_full_points
        race_bet_points = self.__race_full_points
        expected_gp_points = GrandPrixBetPoints(
            season_grand_prix_id='gp1',
            quali_bet_points=quali_bet_points,
            race_bet_points=race_bet_points,
            total_points=quali_bet_points.total_points + race_bet_points.total_points,
        )

        gp_points = GpPointsService(
            gp_bets=gp_bets,
            gp_results=gp_results
        ).calculate_points()

        self.assertEqual(gp_points, expected_gp_points)

    @property
    def __quali_full_points(self) -> QualiBetPoints:
        q3_points = (
            (3 * self.__Q3_P1_TO_P3_POINTS) +
            (7 * self.__Q3_P4_TO_P10_POINTS)
        )
        q2_points = 5 * self.__Q2_POINTS
        q1_points = 5 * self.__Q1_POINTS
        total_multiplier = (
            self.__Q3_MULTIPLIER +
            self.__Q2_MULTIPLIER +
            self.__Q1_MULTIPLIER
        )
        return QualiBetPoints(
            q3_p1_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p2_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p3_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p4_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p5_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p6_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p7_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p8_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p9_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p10_points=self.__Q3_P4_TO_P10_POINTS,
            q2_p11_points=self.__Q2_POINTS,
            q2_p12_points=self.__Q2_POINTS,
            q2_p13_points=self.__Q2_POINTS,
            q2_p14_points=self.__Q2_POINTS,
            q2_p15_points=self.__Q2_POINTS,
            q1_p16_points=self.__Q1_POINTS,
            q1_p17_points=self.__Q1_POINTS,
            q1_p18_points=self.__Q1_POINTS,
            q1_p19_points=self.__Q1_POINTS,
            q1_p20_points=self.__Q1_POINTS,
            q3_points=q3_points,
            q2_points=q2_points,
            q1_points=q1_points,
            q3_multiplier=self.__Q3_MULTIPLIER,
            q2_multiplier=self.__Q2_MULTIPLIER,
            q1_multiplier=self.__Q1_MULTIPLIER,
            total_points=(
                (q3_points + q2_points + q1_points) * total_multiplier
            ),
            multiplier=total_multiplier,
        )

    @property
    def __race_full_points(self) -> RaceBetPoints:
        podium_and_p10_points = (
            self.__P1_POINTS +
            self.__P2_POINTS +
            self.__P3_POINTS +
            self.__P10_POINTS
        )
        dnf_points = 3 * self.__ONE_DNF_POINTS
        return RaceBetPoints(
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
            podium_and_p10_points=podium_and_p10_points,
            podium_and_p10_multiplier=self.__PODIUM_P10_MULTIPLIER,
            dnf_points=dnf_points,
            dnf_multiplier=self.__DNF_MULTIPLIER,
            safety_car_and_red_flag_points=(
                self.__SAFETY_CAR_POINTS + self.__RED_FLAG_POINTS
            ),
            total_points=(
                (podium_and_p10_points * self.__PODIUM_P10_MULTIPLIER) +
                self.__FASTEST_LAP_POINTS +
                (dnf_points * self.__DNF_MULTIPLIER) +
                self.__SAFETY_CAR_POINTS +
                self.__RED_FLAG_POINTS
            ),
        )
