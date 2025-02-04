from typing import List
from models.race_bet_points import RaceBetPoints
from pydantic import BaseModel


class RaceParams(BaseModel):
    p1_driver_id: str | None
    p2_driver_id: str | None
    p3_driver_id: str | None
    p10_driver_id: str | None
    fastest_lap_driver_id: str | None
    dnf_driver_ids: List[str | None] | None
    is_safety_car: bool | None
    is_red_flag: bool | None


class RacePointsService:
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

    def __init__(
        self,
        race_bets: RaceParams,
        race_results: RaceParams,
    ):
        self.race_bets = race_bets
        self.race_results = race_results

    def calculate_points(self) -> RaceBetPoints | None:
        if self.__is_at_least_one_result_param_none:
            return None

        p1_points: float = self.__points_for_p1
        p2_points: float = self.__points_for_p2
        p3_points: float = self.__points_for_p3
        p10_points: float = self.__points_for_p10
        fastest_lap_points: float = self.__points_for_fastest_lap
        points_for_each_dnf: List[float] = self.__points_for_each_dnf
        safety_car_points: float = self.__points_for_safety_car
        red_flag_points: float = self.__points_for_red_flag
        podium_p10_multiplier: float | None = None
        dnf_multiplier: float | None = None

        if (
            p1_points > 0 and
            p2_points > 0 and
            p3_points > 0 and
            p10_points > 0
        ):
            podium_p10_multiplier = self.__PODIUM_P10_MULTIPLIER

        if all(point > 0 for point in points_for_each_dnf):
            dnf_multiplier = self.__DNF_MULTIPLIER

        podium_p10_points: float = p1_points + p2_points + p3_points + p10_points
        dnf_points: float = sum(points_for_each_dnf)
        safety_car_red_flag_points: float = safety_car_points + red_flag_points

        total_points: float = fastest_lap_points + safety_car_red_flag_points
        total_points += (
            podium_p10_points
            if podium_p10_multiplier is None
            else podium_p10_points * podium_p10_multiplier
        )
        total_points += (
            dnf_points
            if dnf_multiplier is None
            else dnf_points * dnf_multiplier
        )

        return RaceBetPoints(
            p1_points=p1_points,
            p2_points=p2_points,
            p3_points=p3_points,
            p10_points=p10_points,
            fastest_lap_points=fastest_lap_points,
            dnf_driver1_points=points_for_each_dnf[0],
            dnf_driver2_points=points_for_each_dnf[1],
            dnf_driver3_points=points_for_each_dnf[2],
            safety_car_points=safety_car_points,
            red_flag_points=red_flag_points,
            podium_and_p10_points=podium_p10_points,
            podium_and_p10_multiplier=podium_p10_multiplier,
            dnf_points=dnf_points,
            dnf_multiplier=dnf_multiplier,
            safety_car_and_red_flag_points=safety_car_red_flag_points,
            total_points=total_points,
        )

    @property
    def __is_at_least_one_result_param_none(self) -> bool:
        return (
            self.race_results.p1_driver_id is None or
            self.race_results.p2_driver_id is None or
            self.race_results.p3_driver_id is None or
            self.race_results.p10_driver_id is None or
            self.race_results.fastest_lap_driver_id is None or
            self.race_results.dnf_driver_ids is None or
            self.race_results.is_safety_car is None or
            self.race_results.is_red_flag is None
        )

    @property
    def __points_for_p1(self) -> float:
        results_p1_driver_id = self.race_results.p1_driver_id

        return self.__P1_POINTS if (
            (
                results_p1_driver_id is not None and
                self.race_bets.p1_driver_id == results_p1_driver_id
            )
        ) else 0

    @property
    def __points_for_p2(self) -> float:
        results_p2_driver_id = self.race_results.p2_driver_id

        return self.__P2_POINTS if (
            (
                results_p2_driver_id is not None and
                self.race_bets.p2_driver_id == results_p2_driver_id
            )
        ) else 0

    @property
    def __points_for_p3(self) -> float:
        results_p3_driver_id = self.race_results.p3_driver_id

        return self.__P3_POINTS if (
            (
                results_p3_driver_id is not None and
                self.race_bets.p3_driver_id == results_p3_driver_id
            )
        ) else 0

    @property
    def __points_for_p10(self) -> float:
        results_p10_driver_id = self.race_results.p10_driver_id

        return self.__P10_POINTS if (
            (
                results_p10_driver_id is not None and
                self.race_bets.p10_driver_id == results_p10_driver_id
            )
        ) else 0

    @property
    def __points_for_fastest_lap(self) -> float:
        results_fastest_lap_driver_id = self.race_results.fastest_lap_driver_id

        return self.__FASTEST_LAP_POINTS if (
            (
                results_fastest_lap_driver_id is not None and
                self.race_bets.fastest_lap_driver_id == results_fastest_lap_driver_id
            )
        ) else 0

    @property
    def __points_for_each_dnf(self) -> List[float]:
        bets_dnf_driver_ids = self.race_bets.dnf_driver_ids
        results_dnf_driver_ids = self.race_results.dnf_driver_ids
        dnf_points = [0, 0, 0]

        if (
            bets_dnf_driver_ids is not None and
            results_dnf_driver_ids is not None
        ):
            for i in range(min(3, len(bets_dnf_driver_ids))):
                if bets_dnf_driver_ids[i] in results_dnf_driver_ids:
                    dnf_points[i] = self.__ONE_DNF_POINTS

        return dnf_points

    @property
    def __points_for_safety_car(self) -> float:
        return self.__SAFETY_CAR_POINTS if (
            self.race_results.is_safety_car is not None and
            self.race_bets.is_safety_car == self.race_results.is_safety_car
        ) else 0

    @property
    def __points_for_red_flag(self) -> float:
        return self.__RED_FLAG_POINTS if (
            self.race_results.is_red_flag is not None and
            self.race_bets.is_red_flag == self.race_results.is_red_flag
        ) else 0
