from typing import List
from google.cloud.firestore_v1.base_query import FieldFilter
from google.cloud.firestore import Client
from firebase_collections_references import (
    FirebaseCollectionsReferences
)
from models.season_grand_prix_bet_points import (
    SeasonGrandPrixBetPoints,
    SeasonGrandPrixBetPointsFields,
)


class SeasonGrandPrixBetPointsDataService:
    def __init__(self, db_client: Client):
        self.collections_references = FirebaseCollectionsReferences(db_client)

    def load_all_from_season(
        self,
        user_id: str,
        season: int,
    ) -> List[SeasonGrandPrixBetPoints]:
        docs = (
            self.collections_references.user_season_grand_prix_bet_points(
                user_id=user_id,
                season=season,
            )
            .stream()
        )

        return [SeasonGrandPrixBetPoints.from_dict(doc.to_dict()) for doc in docs]

    def does_points_for_season_gp_exists(
        self,
        user_id: str,
        season: int,
        season_grand_prix_id: str,
    ) -> bool:
        docs = (
            self.collections_references.user_season_grand_prix_bet_points(
                user_id,
                season
            )
            .where(
                filter=FieldFilter(
                    SeasonGrandPrixBetPointsFields.season_grand_prix_id,
                    "==",
                    season_grand_prix_id
                )
            )
            .limit(1)
            .stream()
        )

        return len(list(docs)) > 0

    def add(
        self,
        user_id: str,
        season: int,
        season_grand_prix_bet_points: SeasonGrandPrixBetPoints,
    ):
        (
            self.collections_references
            .user_season_grand_prix_bet_points(user_id, season)
            .add(season_grand_prix_bet_points.to_dict())
        )

    def update(
        self,
        user_id: str,
        season: int,
        updated_season_grand_prix_bet_points: SeasonGrandPrixBetPoints,
    ):
        docs = (
            self.collections_references.user_season_grand_prix_bet_points(
                user_id,
                season
            )
            .where(
                filter=FieldFilter(
                    SeasonGrandPrixBetPointsFields.season_grand_prix_id,
                    "==",
                    updated_season_grand_prix_bet_points.season_grand_prix_id
                )
            )
            .limit(1)
            .stream()
        )

        for doc in docs:
            (
                self.collections_references.user_season_grand_prix_bet_points(
                    user_id,
                    season
                )
                .document(doc.id)
                .set(updated_season_grand_prix_bet_points.to_dict())
            )
