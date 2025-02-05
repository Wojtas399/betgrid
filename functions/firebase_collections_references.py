from firebase_admin import firestore
from firebase_collections import FirebaseCollections


class FirebaseCollectionsReferences:
    def __init__(self):
        self.db = firestore.client()

    def users(self):
        return self.db.collection(FirebaseCollections.USERS)

    def season_drivers(self):
        return self.db.collection(FirebaseCollections.SEASON_DRIVERS)

    def grand_prix_bets(self, user_id: str):
        return (
            self
            .db
            .collection(FirebaseCollections.USERS)
            .document(user_id)
            .collection(
                FirebaseCollections.USER_COLLECTIONS.GRAND_PRIX_BETS
            )
        )

    def grand_prix_bet_points(self, user_id: str):
        return (
            self
            .db
            .collection(FirebaseCollections.USERS)
            .document(user_id)
            .collection(
                FirebaseCollections.USER_COLLECTIONS.GRAND_PRIX_BETS_POINTS
            )
        )

    def user_stats(self, user_id: str):
        return (
            self
            .db
            .collection(FirebaseCollections.USERS)
            .document(user_id)
            .collection(FirebaseCollections.USER_COLLECTIONS.STATS)
        )
