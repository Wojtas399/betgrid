from firebase_admin import firestore
from .collections import Collections


class CollectionsReferences:
    def __init__(self):
        self.db = firestore.client()

    @property
    def users(self):
        return self.db.collection(Collections.USERS)

    @property
    def season_drivers(self):
        return self.db.collection(Collections.SEASON_DRIVERS)

    @property
    def grand_prix_bets(self, user_id: str):
        return (
            self
            .db
            .collection(Collections.USERS)
            .document(user_id)
            .collection(Collections.USER_COLLECTIONS.GRAND_PRIX_BETS)
        )

    @property
    def grand_prix_bet_points(self, user_id: str):
        return (
            self
            .db
            .collection(Collections.USERS)
            .document(user_id)
            .collection(Collections.USER_COLLECTIONS.GRAND_PRIX_BETS_POINTS)
        )
