from pydantic import BaseModel
from typing import Optional

class RaceBetPoints(BaseModel):
    p1Points: float
    p2Points: float
    p3Points: float
    p10Points: float
    fastestLapPoints: float
    dnfDriver1Points: float
    dnfDriver2Points: float
    dnfDriver3Points: float
    safetyCarPoints: float
    redFlagPoints: float
    podiumAndP10Points: float
    podiumAndP10Multiplier: Optional[float]
    dnfPoints: float
    dnfMultiplier: Optional[float]
    safetyCarAndRedFlagPoints: float
    totalPoints: float