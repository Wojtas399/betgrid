from firebase_admin import firestore
from functions.collections import Collections


class CollectionsReferences:
    def __init__(self):
        self.db = firestore.client()

    def users(self):
        return self.db.collection(Collections.USERS)

    def season_drivers(self):
        return self.db.collection(Collections.SEASON_DRIVERS)

    def grand_prix_bets(self, user_id: str):
        return (
            self
            .db
            .collection(Collections.USERS)
            .document(user_id)
            .collection(Collections.USER_COLLECTIONS.GRAND_PRIX_BETS)
        )

    def grand_prix_bet_points(self, user_id: str):
        return (
            self
            .db
            .collection(Collections.USERS)
            .document(user_id)
            .collection(Collections.USER_COLLECTIONS.GRAND_PRIX_BETS_POINTS)
        )

    def user_stats(self, user_id: str):
        return (
            self
            .db
            .collection(Collections.USERS)
            .document(user_id)
            .collection(Collections.USER_COLLECTIONS.STATS)
        )
