from pydantic import BaseModel

class PlayerStatsPointsForGp(BaseModel):
    season_grand_prix_id: str
    points: float

    @staticmethod
    def from_dict(source):
        return PlayerStatsPointsForGp(
            season_grand_prix_id = source['seasonGrandPrixId'],
            points = source['points'],
        )
    
    def to_dict(self):
        return {
            'seasonGrandPrixId': self.season_grand_prix_id,
            'points': self.points,
        }