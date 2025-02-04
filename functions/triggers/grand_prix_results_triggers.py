from typing import List
from firebase_functions import firestore_fn
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
from functions.service.points import calculate_points_for_gp


class GrandPrixResultsTriggers:
    def __init__(self):
        self.users_data_service = UsersDataService()
        self.grand_prix_bets_data_service = GrandPrixBetsDataService()
        self.grand_prix_bet_points_data_service = GrandPrixBetPointsDataService()

    def on_results_added(
        self,
        event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]
    ):
        if event.data is None:
            return
        try:
            gp_results: GrandPrixResults = GrandPrixResults.from_dict(
                event.data.to_dict()
            )
        except KeyError:
            return

        all_users_ids: List[str] = self.users_data_service.load_ids_of_all_users()
        for user_id in all_users_ids:
            gp_bets: GrandPrixBets = (
                self.grand_prix_bets_data_service.load_bets_for_user_and_grand_prix(
                    user_id=user_id,
                    grand_prix_id=gp_results.season_grand_prix_id
                )
            )
            gp_points: GrandPrixBetPoints = calculate_points_for_gp(
                gp_bets=gp_bets,
                gp_results=gp_results,
            )
            self.grand_prix_bet_points_data_service.add_grand_prix_bet_points(
                user_id=user_id,
                grand_prix_bet_points=gp_points,
            )

    def on_results_updated(
        self,
        event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]
    ):
        if event.data is None:
            return
        try:
            gp_results: GrandPrixResults = GrandPrixResults.from_dict(
                event.data.after.to_dict()
            )
        except KeyError:
            return

        all_users_ids: List[str] = self.users_data_service.load_ids_of_all_users()
        for user_id in all_users_ids:
            gp_bets = (
                self.grand_prix_bets_data_service.load_bets_for_user_and_grand_prix(
                    user_id=user_id,
                    grand_prix_id=gp_results.season_grand_prix_id
                )
            )
            gp_points = calculate_points_for_gp(
                gp_bets=gp_bets,
                gp_results=gp_results,
            )
            self.grand_prix_bet_points_data_service.update_grand_prix_bet_points(
                user_id=user_id,
                updated_grand_prix_bet_points=gp_points,
            )
