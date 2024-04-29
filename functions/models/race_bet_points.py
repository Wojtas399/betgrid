from pydantic import BaseModel
from typing import Optional

class RaceBetPoints(BaseModel):
    p1_points: float
    p2_points: float
    p3_points: float
    p10_points: float
    fastest_lap_points: float
    dnf_driver1_points: float
    dnf_driver2_points: float
    dnf_driver3_points: float
    safety_car_points: float
    red_flag_points: float
    podium_and_p10_points: float
    podium_and_p10_multiplier: Optional[float]
    dnf_points: float
    dnf_multiplier: Optional[float]
    safety_car_and_red_flag_points: float
    total_points: float

    def to_dict(self):
        return {
            'p1Points': self.p1_points,
            'p2Points': self.p2_points,
            'p3Points': self.p3_points,
            'p10Points': self.p10_points,
            'fastestLapPoints': self.fastest_lap_points,
            'dnfDriver1Points': self.dnf_driver1_points,
            'dnfDriver2Points': self.dnf_driver2_points,
            'dnfDriver3Points': self.dnf_driver3_points,
            'safetyCarPoints': self.safety_car_points,
            'redFlagPoints': self.red_flag_points,
            'podiumAndP10Points': self.podium_and_p10_points,
            'podiumAndP10Multiplier': self.podium_and_p10_multiplier,
            'dnfPoints': self.dnf_points,
            'dnfMultiplier': self.dnf_multiplier,
            'safetyCarAndRedFlagPoints': self.safety_car_and_red_flag_points,
            'totalPoints': self.total_points,
        }
