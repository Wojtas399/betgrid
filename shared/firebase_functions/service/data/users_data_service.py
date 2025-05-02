from google.cloud.firestore import Client
from firebase_collections_references import (
    FirebaseCollectionsReferences
)


class UsersDataService:
    def __init__(self, db_client: Client):
        self.collections_references = FirebaseCollectionsReferences(db_client)

    def load_ids_of_all_users(self):
        docs = self.collections_references.users().stream()
        return [doc.id for doc in docs]
