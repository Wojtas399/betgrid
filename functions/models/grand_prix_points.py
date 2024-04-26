from pydantic import BaseModel
from typing import Optional
from models.quali_bet_points import QualiBetPoints
from models.race_bet_points import RaceBetPoints

class GrandPrixPoints(BaseModel):
    grandPrixId: str
    qualiBetPoints: Optional[QualiBetPoints]
    raceBetPoints: Optional[RaceBetPoints]
    totalPoints: float