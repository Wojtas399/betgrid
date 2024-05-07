from pydantic import BaseModel
from typing import Optional

class QualiBetPoints(BaseModel):
    q3_p1_points: float
    q3_p2_points: float
    q3_p3_points: float
    q3_p4_points: float
    q3_p5_points: float
    q3_p6_points: float
    q3_p7_points: float
    q3_p8_points: float
    q3_p9_points: float
    q3_p10_points: float
    q2_p11_points: float
    q2_p12_points: float
    q2_p13_points: float
    q2_p14_points: float
    q2_p15_points: float
    q1_p16_points: float
    q1_p17_points: float
    q1_p18_points: float
    q1_p19_points: float
    q1_p20_points: float
    q3_points: float
    q2_points: float
    q1_points: float
    q3_multiplier: Optional[float]
    q2_multiplier: Optional[float]
    q1_multiplier: Optional[float]
    total_points: float
    multiplier: Optional[float]

    def to_dict(self):
        return {
            'q3P1Points': self.q3_p1_points,
            'q3P2Points': self.q3_p2_points,
            'q3P3Points': self.q3_p3_points,
            'q3P4Points': self.q3_p4_points,
            'q3P5Points': self.q3_p5_points,
            'q3P6Points': self.q3_p6_points,
            'q3P7Points': self.q3_p7_points,
            'q3P8Points': self.q3_p8_points,
            'q3P9Points': self.q3_p9_points,
            'q3P10Points': self.q3_p10_points,
            'q2P11Points': self.q2_p11_points,
            'q2P12Points': self.q2_p12_points,
            'q2P13Points': self.q2_p13_points,
            'q2P14Points': self.q2_p14_points,
            'q2P15Points': self.q2_p15_points,
            'q1P16Points': self.q1_p16_points,
            'q1P17Points': self.q1_p17_points,
            'q1P18Points': self.q1_p18_points,
            'q1P19Points': self.q1_p19_points,
            'q1P20Points': self.q1_p20_points,
            'q3Points': self.q3_points,
            'q2Points': self.q2_points,
            'q1Points': self.q1_points,
            'q3Multiplier': self.q3_multiplier,
            'q2Multiplier': self.q2_multiplier,
            'q1Multiplier': self.q1_multiplier,
            'totalPoints': self.total_points,
            'multiplier': self.multiplier,
        }