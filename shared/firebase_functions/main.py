from firebase_admin import firestore
from firebase_admin import initialize_app, credentials
from firebase_collections import FirebaseCollections
from triggers import GrandPrixResultsTriggers
from firebase_functions.firestore_fn import (
    on_document_created,
    on_document_updated,
    Event,
    DocumentSnapshot
)

cred = credentials.Certificate("./serviceAccountKey.json")
app = initialize_app()


@on_document_created(
    document=(
        (
            FirebaseCollections.SEASON.MAIN +
            "/{season}/" +
            FirebaseCollections.SEASON.GRAND_PRIXES_RESULTS +
            "/{pushId}"
        )
    )
)
def on_grand_prix_results_added(
    event: Event[DocumentSnapshot | None]
) -> None:
    db_client = firestore.client()
    grand_prix_results_triggers = GrandPrixResultsTriggers(db_client)
    if event.data is not None:
        grand_prix_results_triggers.on_results_added(
            json_data=event.data.to_dict(),
            season=event.params["season"]
        )


@on_document_updated(
    document=(
        (
            FirebaseCollections.SEASON.MAIN +
            "/{season}/" +
            FirebaseCollections.SEASON.GRAND_PRIXES_RESULTS +
            "/{docId}"
        )
    )
)
def on_grand_prix_results_updated(
    event: Event[DocumentSnapshot | None]
) -> None:
    db_client = firestore.client()
    grand_prix_results_triggers = GrandPrixResultsTriggers(db_client)
    if event.data is not None:
        grand_prix_results_triggers.on_results_updated(
            json_data=event.data.after.to_dict(),
            season=event.params["season"]
        )
