from pydantic import BaseModel

class PlayerStatsPointsForDriver(BaseModel):
    season_driver_id: str
    points: float

    @staticmethod
    def from_dict(source):
        return PlayerStatsPointsForDriver(
            season_driver_id = source['seasonDriverId'],
            points = source['points'],
        )
    
    def to_dict(self):
        return {
            'seasonDriverId': self.season_driver_id,
            'points': self.points,
        }