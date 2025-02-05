import unittest
from models.quali_bet_points import QualiBetPoints
from service.points.quali_points_service import QualiPointsService


class QualiPointsServiceTest(unittest.TestCase):
    __Q1_POINTS: float = 1.0
    __Q2_POINTS: float = 2.0
    __Q3_P1_TO_P3_POINTS: float = 1.0
    __Q3_P4_TO_P10_POINTS: float = 2.0
    __Q1_MULTIPLIER: float = 1.25
    __Q2_MULTIPLIER: float = 1.5
    __Q3_MULTIPLIER: float = 1.75

    def test_none_quali_bets(self):
        quali_results = [
            'd1',
            'd11',
            'd2',
            'd13',
            'd14',
            'd3',
            'd4',
            'd16',
            'd17',
            'd15',
            'd6',
            'd7',
            'd8',
            'd5',
            'd12',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20'
        ]
        expected_points = QualiBetPoints(
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

        points = QualiPointsService(
            quali_standings_bets=None,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_none_quali_results(self):
        quali_bets = [
            'd1',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
        ]

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=None
        ).calculate_points()

        self.assertEqual(points, None)

    def test_quali_bets_length_lower_than_20(self):
        quali_bets = [
            'd1',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
        ]
        quali_results = [
            'd1',
            'd11',
            'd2',
            'd13',
            'd14',
            'd3',
            'd4',
            'd16',
            'd17',
            'd15',
            'd6',
            'd7',
            'd8',
            'd5',
            'd12',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20'
        ]

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_quali_bets_length_higher_than_20(self):
        quali_bets = [
            'd1',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20',
            'd21'
        ]
        quali_results = [
            'd1',
            'd11',
            'd2',
            'd13',
            'd14',
            'd3',
            'd4',
            'd16',
            'd17',
            'd15',
            'd6',
            'd7',
            'd8',
            'd5',
            'd12',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20'
        ]

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_quali_results_length_lower_than_20(self):
        quali_bets = [
            'd1',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20'
        ]
        quali_results = [
            'd1',
            'd11',
            'd2',
            'd13',
            'd14',
            'd3',
            'd4',
            'd16',
            'd17',
            'd15',
            'd6',
            'd7',
            'd8',
            'd5',
            'd12',
            'd18',
            'd9',
            'd19',
            'd10',
        ]

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_quali_results_length_higher_than_20(self):
        quali_bets = [
            'd1',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20'
        ]
        quali_results = [
            'd1',
            'd11',
            'd2',
            'd13',
            'd14',
            'd3',
            'd4',
            'd16',
            'd17',
            'd15',
            'd6',
            'd7',
            'd8',
            'd5',
            'd12',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20',
            'd21'
        ]

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, None)

    def test_random_points_1(self):
        quali_bets = [
            'd1',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20',
        ]
        quali_results = [
            'd1',
            'd11',
            'd2',
            'd13',
            'd14',
            'd3',
            'd4',
            'd16',
            'd17',
            'd15',
            'd6',
            'd7',
            'd8',
            'd5',
            'd12',
            'd18',
            'd9',
            'd19',
            'd10',
            'd20'
        ]
        q3_points = (
            (3 * self.__Q3_P1_TO_P3_POINTS) +
            (2 * self.__Q3_P4_TO_P10_POINTS)
        )
        q2_points = self.__Q2_POINTS
        expected_points = QualiBetPoints(
            q3_p1_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p2_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p3_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p4_points=0,
            q3_p5_points=0,
            q3_p6_points=0,
            q3_p7_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p8_points=0,
            q3_p9_points=0,
            q3_p10_points=self.__Q3_P4_TO_P10_POINTS,
            q2_p11_points=self.__Q2_POINTS,
            q2_p12_points=0,
            q2_p13_points=0,
            q2_p14_points=0,
            q2_p15_points=0,
            q1_p16_points=self.__Q1_POINTS,
            q1_p17_points=self.__Q1_POINTS,
            q1_p18_points=self.__Q1_POINTS,
            q1_p19_points=self.__Q1_POINTS,
            q1_p20_points=self.__Q1_POINTS,
            q3_points=q3_points,
            q2_points=q2_points,
            q1_points=self.__full_q1_points,
            q3_multiplier=None,
            q2_multiplier=None,
            q1_multiplier=self.__Q1_MULTIPLIER,
            total_points=(
                (
                    self.__full_q1_points + q2_points + q3_points
                ) * self.__Q1_MULTIPLIER
            ),
            multiplier=self.__Q1_MULTIPLIER,
        )

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_random_points_2(self):
        quali_bets = [
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
        ]
        quali_results = [
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
            'd18',
            'd19',
            'd20',
            'd17'
        ]
        q1_points = self.__Q1_POINTS
        multiplier = self.__Q3_MULTIPLIER + self.__Q2_MULTIPLIER
        expected_points = QualiBetPoints(
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
            q1_p17_points=0,
            q1_p18_points=0,
            q1_p19_points=0,
            q1_p20_points=0,
            q3_points=self.__full_q3_points,
            q2_points=self.__full_q2_points,
            q1_points=q1_points,
            q3_multiplier=self.__Q3_MULTIPLIER,
            q2_multiplier=self.__Q2_MULTIPLIER,
            q1_multiplier=None,
            total_points=(
                (
                    self.__full_q3_points +
                    self.__full_q2_points +
                    q1_points
                ) * multiplier
            ),
            multiplier=multiplier,
        )

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_random_points_3(self):
        quali_bets = [
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
        ]
        quali_results = [
            'd1',
            'd3',
            'd2',
            'd4',
            'd6',
            'd5',
            'd7',
            'd9',
            'd8',
            'd10',
            'd12',
            'd11',
            'd13',
            'd15',
            'd14',
            'd16',
            'd19',
            'd18',
            'd20',
            'd17'
        ]
        q3_points = (
            self.__Q3_P1_TO_P3_POINTS +
            (3 * self.__Q3_P4_TO_P10_POINTS)
        )
        q2_points = self.__Q2_POINTS
        q1_points = 2 * self.__Q1_POINTS
        expected_points = QualiBetPoints(
            q3_p1_points=self.__Q3_P1_TO_P3_POINTS,
            q3_p2_points=0,
            q3_p3_points=0,
            q3_p4_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p5_points=0,
            q3_p6_points=0,
            q3_p7_points=self.__Q3_P4_TO_P10_POINTS,
            q3_p8_points=0,
            q3_p9_points=0,
            q3_p10_points=self.__Q3_P4_TO_P10_POINTS,
            q2_p11_points=0,
            q2_p12_points=0,
            q2_p13_points=self.__Q2_POINTS,
            q2_p14_points=0,
            q2_p15_points=0,
            q1_p16_points=self.__Q1_POINTS,
            q1_p17_points=0,
            q1_p18_points=self.__Q1_POINTS,
            q1_p19_points=0,
            q1_p20_points=0,
            q3_points=q3_points,
            q2_points=q2_points,
            q1_points=q1_points,
            q3_multiplier=None,
            q2_multiplier=None,
            q1_multiplier=None,
            total_points=q3_points + q2_points + q1_points,
            multiplier=None,
        )

        points = QualiPointsService(
            quali_standings_bets=quali_bets,
            quali_standings_results=quali_results
        ).calculate_points()

        self.assertEqual(points, expected_points)

    def test_full_points(self):
        quali_standings = [
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
            'd20'
        ]
        multiplier = (
            self.__Q3_MULTIPLIER + self.__Q2_MULTIPLIER + self.__Q1_MULTIPLIER
        )
        expected_points = QualiBetPoints(
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
            q3_points=self.__full_q3_points,
            q2_points=self.__full_q2_points,
            q1_points=self.__full_q1_points,
            q3_multiplier=self.__Q3_MULTIPLIER,
            q2_multiplier=self.__Q2_MULTIPLIER,
            q1_multiplier=self.__Q1_MULTIPLIER,
            total_points=(
                (
                    self.__full_q1_points +
                    self.__full_q2_points +
                    self.__full_q3_points
                ) * multiplier
            ),
            multiplier=multiplier,
        )
        points = QualiPointsService(
            quali_standings_bets=quali_standings,
            quali_standings_results=quali_standings
        ).calculate_points()
        self.assertEqual(points, expected_points)

    @property
    def __full_q3_points(self) -> float:
        return (
            (3 * self.__Q3_P1_TO_P3_POINTS) +
            (7 * self.__Q3_P4_TO_P10_POINTS)
        )

    @property
    def __full_q2_points(self) -> float:
        return 5 * self.__Q2_POINTS

    @property
    def __full_q1_points(self) -> float:
        return 5 * self.__Q1_POINTS
