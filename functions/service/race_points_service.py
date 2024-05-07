from typing import Optional, List
from models.race_bet_points import RaceBetPoints
from pydantic import BaseModel

P1_POINTS = 2
P2_POINTS = 2
P3_POINTS = 2
P10_POINTS = 4
FASTEST_LAP_POINTS = 2
ONE_DNF_POINTS = 1
SAFETY_CAR_POINTS = 1
RED_FLAG_POINTS = 1
PODIUM_P10_MULTIPLIER = 1.5
DNF_MULTIPLIER = 1.5

class RaceParams(BaseModel):
    p1_driver_id: Optional[str]
    p2_driver_id: Optional[str]
    p3_driver_id: Optional[str]
    p10_driver_id: Optional[str]
    fastest_lap_driver_id: Optional[str]
    dnf_driver_ids: Optional[List[Optional[str]]]
    is_safety_car: Optional[bool]
    is_red_flag: Optional[bool]

def is_at_least_one_param_none(params: RaceParams):
    return (
        params.p1_driver_id is None or
        params.p2_driver_id is None or
        params.p3_driver_id is None or
        params.p10_driver_id is None or
        params.fastest_lap_driver_id is None or
        params.dnf_driver_ids is None or
        params.is_safety_car is None or
        params.is_red_flag is None
    )

def calculate_points_for_race(
    race_bets: RaceParams,
    race_results: RaceParams,
) -> Optional[RaceBetPoints]:
    if (is_at_least_one_param_none(race_results)):
        return None
    
    p1_points = 0
    p2_points = 0
    p3_points = 0
    p10_points = 0
    fastest_lap_points = 0
    dnf_driver_1_points = 0
    dnf_driver_2_points = 0
    dnf_driver_3_points = 0
    safety_car_points = 0
    red_flag_points = 0
    podium_p10_multiplier = None
    dnf_multiplier = None

    if (
        race_results.p1_driver_id is not None and
        race_bets.p1_driver_id == race_results.p1_driver_id
    ):
        p1_points = P1_POINTS
    if (
        race_results.p2_driver_id is not None and
        race_bets.p2_driver_id == race_results.p2_driver_id
    ):
        p2_points = P2_POINTS
    if (
        race_results.p3_driver_id is not None and
        race_bets.p3_driver_id == race_results.p3_driver_id
    ):
        p3_points = P3_POINTS
    if (
        race_results.p10_driver_id is not None and
        race_bets.p10_driver_id == race_results.p10_driver_id
    ):
        p10_points = P10_POINTS

    if (p1_points > 0 and p2_points > 0 and p3_points > 0 and p10_points > 0):
        podium_p10_multiplier = PODIUM_P10_MULTIPLIER
    podium_p10_points = p1_points + p2_points + p3_points + p10_points

    if (
        race_results.fastest_lap_driver_id is not None and
        race_bets.fastest_lap_driver_id == race_results.fastest_lap_driver_id
    ):
        fastest_lap_points = FASTEST_LAP_POINTS

    if (
        race_bets.dnf_driver_ids is not None and
        race_results.dnf_driver_ids is not None
    ):
        if (
            len(race_bets.dnf_driver_ids) >= 1 and
            race_bets.dnf_driver_ids[0] in race_results.dnf_driver_ids
        ):
            dnf_driver_1_points = ONE_DNF_POINTS
        if (
            len(race_bets.dnf_driver_ids) >= 2 and
            race_bets.dnf_driver_ids[1] in race_results.dnf_driver_ids
        ):
            dnf_driver_2_points = ONE_DNF_POINTS
        if (
            len(race_bets.dnf_driver_ids) >= 3 and
            race_bets.dnf_driver_ids[2] in race_results.dnf_driver_ids
        ):
            dnf_driver_3_points = ONE_DNF_POINTS

    if (dnf_driver_1_points > 0 and dnf_driver_2_points > 0 and dnf_driver_3_points > 0):
        dnf_multiplier = DNF_MULTIPLIER
    dnf_points = dnf_driver_1_points + dnf_driver_2_points + dnf_driver_3_points

    if (
        race_results.is_safety_car is not None and
        race_bets.is_safety_car == race_results.is_safety_car
    ):
        safety_car_points = SAFETY_CAR_POINTS
    if (
        race_results.is_red_flag is not None and
        race_bets.is_red_flag == race_results.is_red_flag
    ):
        red_flag_points = RED_FLAG_POINTS

    safety_car_red_flag_points = safety_car_points + red_flag_points

    total_points = fastest_lap_points + safety_car_red_flag_points
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
        p1_points = p1_points,
        p2_points = p2_points,
        p3_points = p3_points,
        p10_points = p10_points,
        fastest_lap_points = fastest_lap_points,
        dnf_driver1_points = dnf_driver_1_points,
        dnf_driver2_points = dnf_driver_2_points,
        dnf_driver3_points = dnf_driver_3_points,
        safety_car_points = safety_car_points,
        red_flag_points = red_flag_points,
        podium_and_p10_points = podium_p10_points,
        podium_and_p10_multiplier = podium_p10_multiplier,
        dnf_points = dnf_points,
        dnf_multiplier = dnf_multiplier,
        safety_car_and_red_flag_points = safety_car_red_flag_points,
        total_points = total_points,
    )
    