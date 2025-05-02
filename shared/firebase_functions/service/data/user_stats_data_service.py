from google.cloud.firestore import Client
from firebase_collections_references import FirebaseCollectionsReferences
from models.user_stats import UserStats


class UserStatsDataService:
    def __init__(self, db_client: Client):
        self.collections_references = FirebaseCollectionsReferences(db_client)

    def load_for_user_and_season(
        self,
        user_id: str,
        season: int,
    ) -> UserStats | None:
        doc = (
            self
            .collections_references
            .user_season(user_id, season)
            .get()
        )

        return UserStats.from_dict(doc.to_dict()) if doc.exists else None

    def update_for_user_and_season(
        self,
        user_id: str,
        season: int,
        updated_user_stats: UserStats,
    ):
        (
            self
            .collections_references
            .user_season(user_id, season)
            .set(updated_user_stats.to_dict())
        )
