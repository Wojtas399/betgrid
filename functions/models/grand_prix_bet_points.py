from typing import Optional
from pydantic import BaseModel
from functions.models.quali_bet_points import QualiBetPoints
from functions.models.race_bet_points import RaceBetPoints


class GrandPrixBetPoints(BaseModel):
    season_grand_prix_id: str
    quali_bet_points: Optional[QualiBetPoints]
    race_bet_points: Optional[RaceBetPoints]
    total_points: float

    def to_dict(self):
        return {
            'seasonGrandPrixId': self.season_grand_prix_id,
            'qualiBetPoints': (
                self.quali_bet_points.to_dict()
                if self.quali_bet_points is not None
                else None
            ),
            'raceBetPoints': (
                self.race_bet_points.to_dict()
                if self.race_bet_points is not None
                else None
            ),
            'totalPoints': self.total_points,
        }
