from pydantic import BaseModel
from typing import Optional
from models.quali_bet_points import QualiBetPoints
from models.race_bet_points import RaceBetPoints

class GrandPrixPoints(BaseModel):
    grand_prix_id: str
    quali_bet_points: Optional[QualiBetPoints]
    race_bet_points: Optional[RaceBetPoints]
    total_points: float

    def to_dict(self):
        return {
            'grandPrixId': self.grand_prix_id,
            'qualiBetPoints': self.quali_bet_points.to_dict(),
            'raceBetPoints': self.race_bet_points.to_dict(),
            'totalPoints': self.total_points,
        }