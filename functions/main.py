from firebase_functions import firestore_fn
from firebase_admin import initialize_app, credentials
from google.cloud.firestore_v1.base_query import FieldFilter
from typing import List
from functions.collections_references import CollectionsReferences
from functions.service.data.users_data_service import UsersDataService
from models.grand_prix_results import GrandPrixResults
from models.grand_prix_bets import GrandPrixBets
from models.grand_prix_points import GrandPrixPoints
from service.gp_points_service import calculate_points_for_gp

cred = credentials.Certificate("./serviceAccountKey.json")
app = initialize_app()
collections_references = CollectionsReferences()
users_data_service = UsersDataService()


def get_bets_for_user(user_id: str, grand_prix_id: str) -> GrandPrixBets:
    query = (
        collections_references.grand_prix_bets(user_id)
        .where(filter=FieldFilter("grandPrixId", "==", grand_prix_id))
        .limit(1)
    )
    doc = next(query.stream())
    return GrandPrixBets.from_dict(doc.to_dict())


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
        gp_bets: GrandPrixBets = get_bets_for_user(
            user_id,
            gp_results.grand_prix_id
        )
        gp_points: GrandPrixPoints = calculate_points_for_gp(
            gp_bets=gp_bets,
            gp_results=gp_results,
        )
        (
            collections_references
            .grand_prix_bet_points(user_id)
            .add(gp_points.to_dict())
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
        gp_bets = get_bets_for_user(user_id, gp_results.grand_prix_id)
        gp_points = calculate_points_for_gp(
            gp_bets=gp_bets,
            gp_results=gp_results,
        )
        results_doc_query = (
            collections_references.grand_prix_bet_points(user_id)
            .where(
                filter=FieldFilter(
                    "grandPrixId",
                    "==",
                    gp_results.grand_prix_id
                )
            )
            .limit(1)
        )
        results_doc = next(results_doc_query.stream())
        (
            collections_references.grand_prix_bet_points(user_id)
            .document(results_doc.id)
            .set(gp_points.to_dict())
        )
