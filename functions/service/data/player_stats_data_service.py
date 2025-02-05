from firebase_collections_references import (
    FirebaseCollectionsReferences
)
from models.player_stats import PlayerStats


class PlayerStatsDataService:
    def __init__(self):
        self.collections_references = FirebaseCollectionsReferences()

    def load_player_stats(
        self,
        player_id: str,
        season: int,
    ) -> PlayerStats | None:
        snapshot = (
            self
            .collections_references
            .user_stats(player_id)
            .document(str(season))
            .get()
        )
        if snapshot.exists:
            return PlayerStats.from_dict(snapshot.to_dict())
        return None

    def update_player_stats(
        self,
        player_id: str,
        season: int,
        player_stats: PlayerStats,
    ):
        (
            self
            .collections_references
            .user_stats(player_id)
            .document(str(season))
            .set(player_stats.to_dict())
        )
