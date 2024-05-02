from firebase_functions import firestore_fn
from firebase_admin import initialize_app, firestore, credentials
import google.cloud.firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from typing import List
from models.grand_prix_results import GrandPrixResults
from models.grand_prix_bets import GrandPrixBets
from service.gp_points_service import calculate_points_for_gp

cred = credentials.Certificate("./serviceAccountKey.json")
app = initialize_app()

def get_users_collection():
    firestore_client: google.cloud.firestore.Client = firestore.client()
    return firestore_client.collection('Users')

def get_all_users_ids() -> List[str]:
    return [user.id for user in get_users_collection().stream()]

def get_bets_for_user(user_id: str, grand_prix_id: str) -> GrandPrixBets:
    collection = (
        get_users_collection()
        .document(user_id)
        .collection("GrandPrixBets")
    )
    query = (
        collection
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

    all_users_ids: List[str] = get_all_users_ids()
    for user_id in all_users_ids:
        gp_bets = get_bets_for_user(user_id, gp_results.grand_prix_id)
        gp_points = calculate_points_for_gp(
            gp_bets = gp_bets,
            gp_results = gp_results,
        )
        (
            get_users_collection()
            .document(user_id)
            .collection('GrandPrixPoints')
            .add(gp_points.to_dict())
        )
