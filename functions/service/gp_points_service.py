from models.grand_prix_points import GrandPrixPoints
from models.grand_prix_bets import GrandPrixBets
from models.grand_prix_results import GrandPrixResults
from service.quali_points_service import calculate_points_for_quali
from service.race_points_service import calculate_points_for_race, RaceParams


def calculate_points_for_gp(
    gp_bets: GrandPrixBets,
    gp_results: GrandPrixResults,
) -> GrandPrixPoints:
    quali_points = calculate_points_for_quali(
        gp_bets.quali_standings_by_driver_ids,
        gp_results.quali_standings_by_driver_ids
    )
    race_points = calculate_points_for_race(
        race_bets=RaceParams(
            p1_driver_id=gp_bets.p1_driver_id,
            p2_driver_id=gp_bets.p2_driver_id,
            p3_driver_id=gp_bets.p3_driver_id,
            p10_driver_id=gp_bets.p10_driver_id,
            fastest_lap_driver_id=gp_bets.fastest_lap_driver_id,
            dnf_driver_ids=gp_bets.dnf_driver_ids,
            is_safety_car=gp_bets.will_be_safety_car,
            is_red_flag=gp_bets.will_be_red_flag,
        ),
        race_results=RaceParams(
            p1_driver_id=gp_results.p1_driver_id,
            p2_driver_id=gp_results.p2_driver_id,
            p3_driver_id=gp_results.p3_driver_id,
            p10_driver_id=gp_results.p10_driver_id,
            fastest_lap_driver_id=gp_results.fastest_lap_driver_id,
            dnf_driver_ids=gp_results.dnf_driver_ids,
            is_safety_car=gp_results.was_there_safety_car,
            is_red_flag=gp_results.was_there_red_flag,
        ),
    )
    return GrandPrixPoints(
        season_grand_prix_id=gp_results.season_grand_prix_id,
        quali_bet_points=quali_points,
        race_bet_points=race_points,
        total_points=(
            0
            if quali_points is None
            else quali_points.total_points
        ) + (
            0
            if race_points is None
            else race_points.total_points
        ),
    )
