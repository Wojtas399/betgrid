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
