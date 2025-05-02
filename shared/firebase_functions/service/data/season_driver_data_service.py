from typing import List
from google.cloud.firestore import Client
from firebase_collections_references import FirebaseCollectionsReferences


class SeasonDriverDataService:
    def __init__(self, db_client: Client):
        self.collections_references = FirebaseCollectionsReferences(db_client)

    def load_ids_of_all_drivers_from_season(self, season: int) -> List[str]:
        docs = self.collections_references.season_drivers(season).stream()
        return [doc.id for doc in docs]
