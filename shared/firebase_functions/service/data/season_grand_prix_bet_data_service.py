from google.cloud.firestore_v1.base_query import FieldFilter
from google.cloud.firestore import Client
from firebase_collections_references import (
    FirebaseCollectionsReferences
)
from models.season_grand_prix_bet import (
    SeasonGrandPrixBet,
    SeasonGrandPrixBetFields,
)


class SeasonGrandPrixBetDataService:
    def __init__(self, db_client: Client):
        self.collections_references = FirebaseCollectionsReferences(db_client)

    def load_for_season_grand_prix(
        self,
        user_id: str,
        season: int,
        season_grand_prix_id: str,
    ) -> SeasonGrandPrixBet | None:
        docs = (
            self.collections_references.user_season_grand_prix_bets(
                user_id=user_id,
                season=season,
            )
            .where(
                filter=FieldFilter(
                    SeasonGrandPrixBetFields.season_grand_prix_id,
                    "==",
                    season_grand_prix_id
                )
            )
            .limit(1)
            .stream()
        )

        for doc in docs:
            return SeasonGrandPrixBet.from_dict(doc.to_dict())

    def load_for_user_and_season_grand_prix(
        self,
        user_id: str,
        season: int,
        season_grand_prix_id: str
    ) -> SeasonGrandPrixBet | None:
        docs = (
            self.collections_references.user_season_grand_prix_bets(
                user_id,
                season,
            )
            .where(
                filter=FieldFilter(
                    SeasonGrandPrixBetFields.season_grand_prix_id,
                    "==",
                    season_grand_prix_id
                )
            )
            .limit(1)
            .stream()
        )

        for doc in docs:
            return SeasonGrandPrixBet.from_dict(doc.to_dict())
