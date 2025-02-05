from models import (
    QualiBetPoints,
    RaceBetPoints,
    GrandPrixBetPoints,
    GrandPrixBets,
    GrandPrixResults,
)
from service.points.race_points_service import RacePointsService, RaceParams
from service.points.quali_points_service import QualiPointsService


class GpPointsService:
    def __init__(
        self,
        gp_bets: GrandPrixBets,
        gp_results: GrandPrixResults,
    ):
        self.season_grand_prix_id = gp_results.season_grand_prix_id
        self.quali_points_service = QualiPointsService(
            quali_standings_bets=gp_bets.quali_standings_by_driver_ids,
            quali_standings_results=gp_results.quali_standings_by_driver_ids
        )
        self.race_points_service = RacePointsService(
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

    def calculate_points(self) -> GrandPrixBetPoints:
        quali_points: QualiBetPoints | None = (
            self.quali_points_service.calculate_points()
        )
        race_points: RaceBetPoints | None = (
            self.race_points_service.calculate_points()
        )
        quali_total_points: float = (
            0
            if quali_points is None
            else quali_points.total_points
        )
        race_total_points: float = (
            0
            if race_points is None
            else race_points.total_points
        )

        return GrandPrixBetPoints(
            season_grand_prix_id=self.season_grand_prix_id,
            quali_bet_points=quali_points,
            race_bet_points=race_points,
            total_points=quali_total_points + race_total_points,
        )
