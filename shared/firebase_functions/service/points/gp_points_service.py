from models import (
    QualiBetPoints,
    RaceBetPoints,
    SeasonGrandPrixBetPoints,
    SeasonGrandPrixBet,
    SeasonGrandPrixResults,
)
from service.points.race_points_service import RacePointsService, RaceParams
from service.points.quali_points_service import QualiPointsService


class GpPointsService:
    def __init__(
        self,
        gp_bet: SeasonGrandPrixBet | None,
        gp_results: SeasonGrandPrixResults,
    ):
        self.season_grand_prix_id = gp_results.season_grand_prix_id
        self.quali_points_service = QualiPointsService(
            quali_standings_bets=(
                gp_bet.quali_standings_by_season_driver_ids
                if gp_bet is not None
                else None
            ),
            quali_standings_results=gp_results.quali_standings_by_season_driver_ids
        )
        self.race_points_service = RacePointsService(
            race_bets=(
                RaceParams(
                    p1_season_driver_id=gp_bet.p1_season_driver_id,
                    p2_season_driver_id=gp_bet.p2_season_driver_id,
                    p3_season_driver_id=gp_bet.p3_season_driver_id,
                    p10_season_driver_id=gp_bet.p10_season_driver_id,
                    fastest_lap_season_driver_id=gp_bet.fastest_lap_season_driver_id,
                    dnf_season_driver_ids=gp_bet.dnf_season_driver_ids,
                    is_safety_car=gp_bet.will_be_safety_car,
                    is_red_flag=gp_bet.will_be_red_flag,
                )
                if gp_bet is not None
                else None
            ),
            race_results=RaceParams(
                p1_season_driver_id=gp_results.p1_season_driver_id,
                p2_season_driver_id=gp_results.p2_season_driver_id,
                p3_season_driver_id=gp_results.p3_season_driver_id,
                p10_season_driver_id=gp_results.p10_season_driver_id,
                fastest_lap_season_driver_id=gp_results.fastest_lap_season_driver_id,
                dnf_season_driver_ids=gp_results.dnf_season_driver_ids,
                is_safety_car=gp_results.was_there_safety_car,
                is_red_flag=gp_results.was_there_red_flag,
            ),
        )

    def calculate_points(self) -> SeasonGrandPrixBetPoints:
        quali_points: QualiBetPoints | None = (
            self.quali_points_service.calculate_points()
        )
        race_points: RaceBetPoints | None = (
            self.race_points_service.calculate_points()
        )
        quali_total_points: float = (
            0
            if quali_points is None
            else quali_points.total
        )
        race_total_points: float = (
            0
            if race_points is None
            else race_points.total
        )

        return SeasonGrandPrixBetPoints(
            season_grand_prix_id=self.season_grand_prix_id,
            quali=quali_points,
            race=race_points,
            total=quali_total_points + race_total_points,
        )
