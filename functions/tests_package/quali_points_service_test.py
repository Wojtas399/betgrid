import unittest
from models.quali_bet_points import QualiBetPoints
from functions.service.quali_points_service import calculate_points_for_quali

class QualiPointsServiceTest(unittest.TestCase):
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
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        expected_points = QualiBetPoints(
            q3_p1_points = 1,
            q3_p2_points = 1,
            q3_p3_points = 1,
            q3_p4_points = 0,
            q3_p5_points = 0,
            q3_p6_points = 0,
            q3_p7_points = 2,
            q3_p8_points = 0,
            q3_p9_points = 0,
            q3_p10_points = 2,
            q2_p11_points = 2,
            q2_p12_points = 0,
            q2_p13_points = 0,
            q2_p14_points = 0,
            q2_p15_points = 0,
            q1_p16_points = 1,
            q1_p17_points = 1,
            q1_p18_points = 1,
            q1_p19_points = 1,
            q1_p20_points = 1,
            q3_points = 7,
            q2_points = 2,
            q1_points = 5,
            q3_multiplier = None,
            q2_multiplier = None,
            q1_multiplier = 1.25,
            total_points = 14 * 1.25,
            multiplier = 1.25,
        )
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        expected_points = QualiBetPoints(
            q3_p1_points = 1,
            q3_p2_points = 1,
            q3_p3_points = 1,
            q3_p4_points = 2,
            q3_p5_points = 2,
            q3_p6_points = 2,
            q3_p7_points = 2,
            q3_p8_points = 2,
            q3_p9_points = 2,
            q3_p10_points = 2,
            q2_p11_points = 2,
            q2_p12_points = 2,
            q2_p13_points = 2,
            q2_p14_points = 2,
            q2_p15_points = 2,
            q1_p16_points = 1,
            q1_p17_points = 0,
            q1_p18_points = 0,
            q1_p19_points = 0,
            q1_p20_points = 0,
            q3_points = 17,
            q2_points = 10,
            q1_points = 1,
            q3_multiplier = 1.75,
            q2_multiplier = 1.5,
            q1_multiplier = None,
            total_points = 28 * (1.75 + 1.5),
            multiplier = 1.75 + 1.5,
        )
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        expected_points = QualiBetPoints(
            q3_p1_points = 1,
            q3_p2_points = 0,
            q3_p3_points = 0,
            q3_p4_points = 2,
            q3_p5_points = 0,
            q3_p6_points = 0,
            q3_p7_points = 2,
            q3_p8_points = 0,
            q3_p9_points = 0,
            q3_p10_points = 2,
            q2_p11_points = 0,
            q2_p12_points = 0,
            q2_p13_points = 2,
            q2_p14_points = 0,
            q2_p15_points = 0,
            q1_p16_points = 1,
            q1_p17_points = 0,
            q1_p18_points = 1,
            q1_p19_points = 0,
            q1_p20_points = 0,
            q3_points = 7,
            q2_points = 2,
            q1_points = 2,
            q3_multiplier = None,
            q2_multiplier = None,
            q1_multiplier = None,
            total_points = 11,
            multiplier = None,
        )
        points = calculate_points_for_quali(quali_bets, quali_results)
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
        expected_points = QualiBetPoints(
            q3_p1_points = 1,
            q3_p2_points = 1,
            q3_p3_points = 1,
            q3_p4_points = 2,
            q3_p5_points = 2,
            q3_p6_points = 2,
            q3_p7_points = 2,
            q3_p8_points = 2,
            q3_p9_points = 2,
            q3_p10_points = 2,
            q2_p11_points = 2,
            q2_p12_points = 2,
            q2_p13_points = 2,
            q2_p14_points = 2,
            q2_p15_points = 2,
            q1_p16_points = 1,
            q1_p17_points = 1,
            q1_p18_points = 1,
            q1_p19_points = 1,
            q1_p20_points = 1,
            q3_points = 17,
            q2_points = 10,
            q1_points = 5,
            q3_multiplier = 1.75,
            q2_multiplier = 1.5,
            q1_multiplier = 1.25,
            total_points = 32 * (1.75 + 1.5 + 1.25),
            multiplier = (1.75 + 1.5 + 1.25),
        )
        points = calculate_points_for_quali(quali_standings, quali_standings)
        self.assertEqual(points, expected_points)