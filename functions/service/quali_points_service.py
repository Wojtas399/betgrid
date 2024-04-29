from typing import List, Optional
from models.quali_bet_points import QualiBetPoints

Q1_POINTS = 1
Q2_POINTS = 2
Q3_P1_TO_P3_POINTS = 1
Q3_P4_TO_P10_POINTS = 2
Q1_MULTIPLIER = 1.25
Q2_MULTIPLIER = 1.5
Q3_MULTIPLIER = 1.75

def calculate_points_for_quali(
    bets_quali_standings: List[str], 
    results_quali_standings: List[str]
) -> Optional[QualiBetPoints]:
    if (
        len(bets_quali_standings) is not 20 or
        len(results_quali_standings) is not 20
    ):
        return None
    points_for_each_place_in_q1: List[int] = []
    points_for_each_place_in_q2: List[int] = []
    points_for_each_place_in_q3: List[int] = []
    for i in range(5):
        points_for_each_place_in_q1.append(
            (
                Q1_POINTS 
                if bets_quali_standings[15+i] == results_quali_standings[15+i] 
                else 0
            )
        )
        points_for_each_place_in_q2.append(
            (
                Q2_POINTS 
                if bets_quali_standings[10+i] == results_quali_standings[10+i] 
                else 0
            )
        )
    for i in range(10):
        points_for_each_place_in_q3.append(
            0 if bets_quali_standings[i] != results_quali_standings[i] else 
            Q3_P1_TO_P3_POINTS if i < 3 else 
            Q3_P4_TO_P10_POINTS
        )
    q1_multiplier = (
        Q1_MULTIPLIER 
        if all(points > 0 for points in points_for_each_place_in_q1) 
        else 0
    )
    q2_multiplier = (
        Q2_MULTIPLIER 
        if all(points > 0 for points in points_for_each_place_in_q2) 
        else 0
    )
    q3_multiplier = (
        Q3_MULTIPLIER 
        if all(points > 0 for points in points_for_each_place_in_q3) 
        else 0
    )
    multiplier = q1_multiplier + q2_multiplier + q3_multiplier
    q1_points = sum(points_for_each_place_in_q1)
    q2_points = sum(points_for_each_place_in_q2)
    q3_points = sum(points_for_each_place_in_q3)
    total_points = q1_points + q2_points + q3_points
    if (multiplier > 0):
        total_points *= multiplier
    return QualiBetPoints(
        q3_p1_points = points_for_each_place_in_q3[0],
        q3_p2_points = points_for_each_place_in_q3[1],
        q3_p3_points = points_for_each_place_in_q3[2],
        q3_p4_points = points_for_each_place_in_q3[3],
        q3_p5_points = points_for_each_place_in_q3[4],
        q3_p6_points = points_for_each_place_in_q3[5],
        q3_p7_points = points_for_each_place_in_q3[6],
        q3_p8_points = points_for_each_place_in_q3[7],
        q3_p9_points = points_for_each_place_in_q3[8],
        q3_p10_points = points_for_each_place_in_q3[9],
        q2_p11_points = points_for_each_place_in_q2[0],
        q2_p12_points = points_for_each_place_in_q2[1],
        q2_p13_points = points_for_each_place_in_q2[2],
        q2_p14_points = points_for_each_place_in_q2[3],
        q2_p15_points = points_for_each_place_in_q2[4],
        q1_p16_points = points_for_each_place_in_q1[0],
        q1_p17_points = points_for_each_place_in_q1[1],
        q1_p18_points = points_for_each_place_in_q1[2],
        q1_p19_points = points_for_each_place_in_q1[3],
        q1_p20_points = points_for_each_place_in_q1[4],
        q3_points = q3_points,
        q2_points = q2_points,
        q1_points = q1_points,
        q3_multiplier = None if q3_multiplier == 0 else q3_multiplier,
        q2_multiplier = None if q2_multiplier == 0 else q2_multiplier,
        q1_multiplier = None if q1_multiplier == 0 else q1_multiplier,
        total_points = total_points,
        multiplier = None if multiplier == 0 else multiplier
    )