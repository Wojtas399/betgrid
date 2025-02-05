from typing import List
from functions.models.quali_bet_points import QualiBetPoints


class QualiPointsService:
    __Q1_POINTS: float = 1.0
    __Q2_POINTS: float = 2.0
    __Q3_P1_TO_P3_POINTS: float = 1.0
    __Q3_P4_TO_P10_POINTS: float = 2.0
    __Q1_MULTIPLIER: float = 1.25
    __Q2_MULTIPLIER: float = 1.5
    __Q3_MULTIPLIER: float = 1.75

    def __init__(
        self,
        quali_standings_bets: List[str] | None,
        quali_standings_results: List[str] | None
    ):
        self.quali_standings_bets = quali_standings_bets
        self.quali_standings_results = quali_standings_results

    def calculate_points(self) -> QualiBetPoints | None:
        if self.__are_params_invalid:
            return None

        [
            q1_place_points,
            q2_place_points,
            q3_place_points
        ] = self.__points_for_each_place_in_qualis

        q1_total_points: float = sum(q1_place_points)
        q2_total_points: float = sum(q2_place_points)
        q3_total_points: float = sum(q3_place_points)

        q1_multiplier: float = (
            self.__Q1_MULTIPLIER
            if self.__are_all_points_scored(q1_place_points)
            else 0
        )
        q2_multiplier: float = (
            self.__Q2_MULTIPLIER
            if self.__are_all_points_scored(q2_place_points)
            else 0
        )
        q3_multiplier: float = (
            self.__Q3_MULTIPLIER
            if self.__are_all_points_scored(q3_place_points)
            else 0
        )
        multiplier: float = q1_multiplier + q2_multiplier + q3_multiplier

        total_points: float = q1_total_points + q2_total_points + q3_total_points
        if multiplier > 0:
            total_points *= multiplier

        return QualiBetPoints(
            q3_p1_points=q3_place_points[0],
            q3_p2_points=q3_place_points[1],
            q3_p3_points=q3_place_points[2],
            q3_p4_points=q3_place_points[3],
            q3_p5_points=q3_place_points[4],
            q3_p6_points=q3_place_points[5],
            q3_p7_points=q3_place_points[6],
            q3_p8_points=q3_place_points[7],
            q3_p9_points=q3_place_points[8],
            q3_p10_points=q3_place_points[9],
            q2_p11_points=q2_place_points[0],
            q2_p12_points=q2_place_points[1],
            q2_p13_points=q2_place_points[2],
            q2_p14_points=q2_place_points[3],
            q2_p15_points=q2_place_points[4],
            q1_p16_points=q1_place_points[0],
            q1_p17_points=q1_place_points[1],
            q1_p18_points=q1_place_points[2],
            q1_p19_points=q1_place_points[3],
            q1_p20_points=q1_place_points[4],
            q3_points=q3_total_points,
            q2_points=q2_total_points,
            q1_points=q1_total_points,
            q3_multiplier=None if q3_multiplier == 0 else q3_multiplier,
            q2_multiplier=None if q2_multiplier == 0 else q2_multiplier,
            q1_multiplier=None if q1_multiplier == 0 else q1_multiplier,
            total_points=total_points,
            multiplier=None if multiplier == 0 else multiplier
        )

    @property
    def __are_params_invalid(self) -> bool:
        return bool(
            self.quali_standings_results is None or
            (
                self.quali_standings_bets is not None and
                (
                    len(self.quali_standings_bets) != 20 or
                    len(self.quali_standings_results) != 20
                )
            )
        )

    @property
    def __points_for_each_place_in_qualis(self) -> List[List[float]]:
        q1_place_points: List[float] = [0.0] * 5
        q2_place_points: List[float] = [0.0] * 5
        q3_place_points: List[float] = [0.0] * 10
        if self.quali_standings_bets is not None:
            for i in range(5):
                bet_q1_place_driver_id: str = self.quali_standings_bets[15+i]
                bet_q2_place_driver_id: str = self.quali_standings_bets[10+i]
                result_q1_place_driver_id: str = self.quali_standings_results[15+i]
                result_q2_place_driver_id: str = self.quali_standings_results[10+i]

                if bet_q1_place_driver_id == result_q1_place_driver_id:
                    q1_place_points[i] = self.__Q1_POINTS
                if bet_q2_place_driver_id == result_q2_place_driver_id:
                    q2_place_points[i] = self.__Q2_POINTS

            for i in range(10):
                bet_q3_place_driver_id: str = self.quali_standings_bets[i]
                result_q3_place_driver_id: str = self.quali_standings_results[i]

                if bet_q3_place_driver_id == result_q3_place_driver_id:
                    q3_place_points[i] = (
                        self.__Q3_P1_TO_P3_POINTS if i < 3 else
                        self.__Q3_P4_TO_P10_POINTS
                    )

        return [q1_place_points, q2_place_points, q3_place_points]

    def __are_all_points_scored(
        self,
        points: List[float]
    ) -> bool:
        return all(points > 0 for points in points)
