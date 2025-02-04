from functions.models import (
    GrandPrixResults,
    GrandPrixBets,
    GrandPrixBetPoints,
)
from functions.service.data import (
    GrandPrixBetPointsDataService,
    GrandPrixBetsDataService,
    UsersDataService,
)
from functions.service.points import GpPointsService


class GrandPrixResultsTriggers:
    def __init__(self):
        self.users_data_service = UsersDataService()
        self.grand_prix_bets_data_service = GrandPrixBetsDataService()
        self.grand_prix_bet_points_data_service = GrandPrixBetPointsDataService()

    def on_results_added(
        self,
        json_data: dict,
        season: int,
    ):

        gp_results: GrandPrixResults = GrandPrixResults.from_dict(json_data)

        all_users_ids = self.users_data_service.load_ids_of_all_users()
        for user_id in all_users_ids:
            gp_bets: GrandPrixBets = (
                self
                .grand_prix_bets_data_service
                .load_bets_for_user_and_grand_prix(
                    user_id=user_id,
                    grand_prix_id=gp_results.season_grand_prix_id
                )
            )
            gp_points: GrandPrixBetPoints = GpPointsService(
                gp_bets=gp_bets,
                gp_results=gp_results,
            ).calculate_points()

            self.grand_prix_bet_points_data_service.add_grand_prix_bet_points(
                user_id=user_id,
                grand_prix_bet_points=gp_points,
            )

    def on_results_updated(
        self,
        json_data: dict,
        season: int,
    ):
        gp_results: GrandPrixResults = GrandPrixResults.from_dict(json_data)

        all_users_ids = self.users_data_service.load_ids_of_all_users()
        for user_id in all_users_ids:
            gp_bets: GrandPrixBets = (
                self
                .grand_prix_bets_data_service
                .load_bets_for_user_and_grand_prix(
                    user_id=user_id,
                    grand_prix_id=gp_results.season_grand_prix_id
                )
            )
            gp_points: GrandPrixBetPoints = GpPointsService(
                gp_bets=gp_bets,
                gp_results=gp_results,
            ).calculate_points()

            (
                self
                .grand_prix_bet_points_data_service
                .update_grand_prix_bet_points(
                    user_id=user_id,
                    updated_grand_prix_bet_points=gp_points,
                )
            )
