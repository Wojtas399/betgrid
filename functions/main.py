from firebase_functions import firestore_fn
from firebase_admin import initialize_app, credentials
from typing import List
from functions.service.data.grand_prix_bet_points_data_service import GrandPrixBetPointsDataService
from functions.service.data.grand_prix_bets_data_service import GrandPrixBetsDataService
from functions.service.data.users_data_service import UsersDataService
from models.grand_prix_results import GrandPrixResults
from models.grand_prix_bets import GrandPrixBets
from functions.models.grand_prix_bet_points import GrandPrixBetPoints
from service.gp_points_service import calculate_points_for_gp

cred = credentials.Certificate("./serviceAccountKey.json")
app = initialize_app()
users_data_service = UsersDataService()
grand_prix_bets_data_service = GrandPrixBetsDataService()
grand_prix_bet_points_data_service = GrandPrixBetPointsDataService()


@firestore_fn.on_document_created(document="GrandPrixResults/{pushId}")
def calculatepoints(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]
) -> None:
    if event.data is None:
        return
    try:
        gp_results: GrandPrixResults = GrandPrixResults.from_dict(
            event.data.to_dict()
        )
    except KeyError:
        return

    all_users_ids: List[str] = users_data_service.load_ids_of_all_users()
    for user_id in all_users_ids:
        gp_bets: GrandPrixBets = (
            grand_prix_bets_data_service.load_bets_for_user_and_grand_prix(
                user_id=user_id,
                grand_prix_id=gp_results.season_grand_prix_id
            )
        )
        gp_points: GrandPrixBetPoints = calculate_points_for_gp(
            gp_bets=gp_bets,
            gp_results=gp_results,
        )
        grand_prix_bet_points_data_service.add_grand_prix_bet_points(
            user_id=user_id,
            grand_prix_bet_points=gp_points,
        )


@firestore_fn.on_document_updated(document="GrandPrixResults/{docId}")
def recalculatepoints(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]
) -> None:
    if event.data is None:
        return
    try:
        gp_results: GrandPrixResults = GrandPrixResults.from_dict(
            event.data.after.to_dict()
        )
    except KeyError:
        return

    all_users_ids: List[str] = users_data_service.load_ids_of_all_users()
    for user_id in all_users_ids:
        gp_bets = (
            grand_prix_bets_data_service.load_bets_for_user_and_grand_prix(
                user_id=user_id,
                grand_prix_id=gp_results.season_grand_prix_id
            )
        )
        gp_points = calculate_points_for_gp(
            gp_bets=gp_bets,
            gp_results=gp_results,
        )
        grand_prix_bet_points_data_service.update_grand_prix_bet_points(
            user_id=user_id,
            updated_grand_prix_bet_points=gp_points,
        )
