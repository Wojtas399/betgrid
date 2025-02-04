from firebase_admin import initialize_app, credentials
from firebase_functions.firestore_fn import (
    on_document_created,
    on_document_updated,
    Event,
    DocumentSnapshot
)
from functions.collections import Collections
from functions.triggers import GrandPrixResultsTriggers

cred = credentials.Certificate("./serviceAccountKey.json")
app = initialize_app()
grand_prix_results_triggers = GrandPrixResultsTriggers()


@on_document_created(
    document=Collections.GRAND_PRIX_RESULTS + "/{season}/Results/{pushId}"
)
def onresultsadded(
    event: Event[DocumentSnapshot | None]
) -> None:
    if event.data is not None:
        grand_prix_results_triggers.on_results_added(
            json_data=event.data.to_dict(),
            season=event.params["season"]
        )


@on_document_updated(
    document=Collections.GRAND_PRIX_RESULTS + "/{season}/Results/{docId}"
)
def onresultsupdated(
    event: Event[DocumentSnapshot | None]
) -> None:
    if event.data is not None:
        grand_prix_results_triggers.on_results_updated(
            json_data=event.data.to_dict(),
            season=event.params["season"]
        )
