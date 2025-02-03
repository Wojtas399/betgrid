from google.cloud.firestore_v1.base_query import FieldFilter
from functions.collections_references import CollectionsReferences
from functions.models.grand_prix_bet_points import GrandPrixBetPoints


class GrandPrixBetPointsDataService:
    def __init__(self):
        self.collections_references = CollectionsReferences()

    def add_grand_prix_bet_points(
        self,
        user_id: str,
        grand_prix_bet_points: GrandPrixBetPoints,
    ):
        (
            self.collections_references
            .grand_prix_bet_points(user_id)
            .add(grand_prix_bet_points.to_dict())
        )

    def update_grand_prix_bet_points(
        self,
        user_id: str,
        updated_grand_prix_bet_points: GrandPrixBetPoints,
    ):
        points_doc_query = (
            self.collections_references.grand_prix_bet_points(user_id)
            .where(
                filter=FieldFilter(
                    "seasonGrandPrixId",
                    "==",
                    updated_grand_prix_bet_points.season_grand_prix_id
                )
            )
            .limit(1)
        )

        points_doc = points_doc_query.stream()[0]

        (
            self.collections_references.grand_prix_bet_points(user_id)
            .document(points_doc.id)
            .set(updated_grand_prix_bet_points.to_dict())
        )
