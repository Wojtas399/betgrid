from google.cloud.firestore import Client
from models import (
    SeasonGrandPrixResults,
    SeasonGrandPrixBet,
    SeasonGrandPrixBetPoints,
)
from service.data import (
    SeasonGrandPrixBetPointsDataService,
    SeasonGrandPrixBetDataService,
    UsersDataService,
)
from service.points import GpPointsService
from service.stats import UserStatsService


class GrandPrixResultsTriggers:
    def __init__(self, db_client: Client):
        self.users_data_service = UsersDataService(db_client)
        self.season_grand_prix_bet_data_service = SeasonGrandPrixBetDataService(
            db_client
        )
        self.season_grand_prix_bet_points_data_service = (
            SeasonGrandPrixBetPointsDataService(db_client)
        )
        self.user_stats_service = UserStatsService(db_client)

    def on_results_added(
        self,
        json_data: dict,
        season: int,
    ):
        season_gp_results = SeasonGrandPrixResults.from_dict(json_data)
        all_users_ids = self.users_data_service.load_ids_of_all_users()

        for user_id in all_users_ids:
            season_gp_bet: SeasonGrandPrixBet = (
                self
                .season_grand_prix_bet_data_service
                .load_for_user_and_season_grand_prix(
                    user_id=user_id,
                    season=season,
                    season_grand_prix_id=season_gp_results.season_grand_prix_id
                )
            )
            season_gp_bet_points: SeasonGrandPrixBetPoints = GpPointsService(
                gp_bet=season_gp_bet,
                gp_results=season_gp_results,
            ).calculate_points()

            self.season_grand_prix_bet_points_data_service.add(
                user_id=user_id,
                season=season,
                season_grand_prix_bet_points=season_gp_bet_points,
            )
            self.user_stats_service.calculate_stats_for_user_season(
                user_id=user_id,
                season=season,
            )

    def on_results_updated(
        self,
        json_data: dict,
        season: int,
    ):
        season_gp_results = SeasonGrandPrixResults.from_dict(json_data)
        all_users_ids = self.users_data_service.load_ids_of_all_users()

        for user_id in all_users_ids:
            season_gp_bet: SeasonGrandPrixBet = (
                self
                .season_grand_prix_bet_data_service
                .load_for_user_and_season_grand_prix(
                    user_id=user_id,
                    season=season,
                    season_grand_prix_id=season_gp_results.season_grand_prix_id
                )
            )
            season_gp_bet_points: SeasonGrandPrixBetPoints = GpPointsService(
                gp_bet=season_gp_bet,
                gp_results=season_gp_results,
            ).calculate_points()

            if self.season_grand_prix_bet_points_data_service.does_points_for_season_gp_exists(
                user_id=user_id,
                season=season,
                season_grand_prix_id=season_gp_results.season_grand_prix_id
            ):
                self.season_grand_prix_bet_points_data_service.update(
                    user_id=user_id,
                    season=season,
                    updated_season_grand_prix_bet_points=season_gp_bet_points,
                )
            else:
                self.season_grand_prix_bet_points_data_service.add(
                    user_id=user_id,
                    season=season,
                    season_grand_prix_bet_points=season_gp_bet_points,
                )
            self.user_stats_service.calculate_stats_for_user_season(
                user_id=user_id,
                season=season,
            )
