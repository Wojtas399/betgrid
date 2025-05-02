class QualiBetPoints:
    def __init__(
        self,
        q3_p1: float,
        q3_p2: float,
        q3_p3: float,
        q3_p4: float,
        q3_p5: float,
        q3_p6: float,
        q3_p7: float,
        q3_p8: float,
        q3_p9: float,
        q3_p10: float,
        q2_p11: float,
        q2_p12: float,
        q2_p13: float,
        q2_p14: float,
        q2_p15: float,
        q1_p16: float,
        q1_p17: float,
        q1_p18: float,
        q1_p19: float,
        q1_p20: float,
        q3: float,
        q2: float,
        q1: float,
        q3_multiplier: float | None,
        q2_multiplier: float | None,
        q1_multiplier: float | None,
        total: float,
        multiplier: float | None,
    ):
        self.q3_p1 = q3_p1
        self.q3_p2 = q3_p2
        self.q3_p3 = q3_p3
        self.q3_p4 = q3_p4
        self.q3_p5 = q3_p5
        self.q3_p6 = q3_p6
        self.q3_p7 = q3_p7
        self.q3_p8 = q3_p8
        self.q3_p9 = q3_p9
        self.q3_p10 = q3_p10
        self.q2_p11 = q2_p11
        self.q2_p12 = q2_p12
        self.q2_p13 = q2_p13
        self.q2_p14 = q2_p14
        self.q2_p15 = q2_p15
        self.q1_p16 = q1_p16
        self.q1_p17 = q1_p17
        self.q1_p18 = q1_p18
        self.q1_p19 = q1_p19
        self.q1_p20 = q1_p20
        self.q3 = q3
        self.q2 = q2
        self.q1 = q1
        self.q3_multiplier = q3_multiplier
        self.q2_multiplier = q2_multiplier
        self.q1_multiplier = q1_multiplier
        self.total = total
        self.multiplier = multiplier

    @staticmethod
    def from_dict(source):
        return QualiBetPoints(
            q3_p1=source[QualiBetPointsFields.q3_p1],
            q3_p2=source[QualiBetPointsFields.q3_p2],
            q3_p3=source[QualiBetPointsFields.q3_p3],
            q3_p4=source[QualiBetPointsFields.q3_p4],
            q3_p5=source[QualiBetPointsFields.q3_p5],
            q3_p6=source[QualiBetPointsFields.q3_p6],
            q3_p7=source[QualiBetPointsFields.q3_p7],
            q3_p8=source[QualiBetPointsFields.q3_p8],
            q3_p9=source[QualiBetPointsFields.q3_p9],
            q3_p10=source[QualiBetPointsFields.q3_p10],
            q2_p11=source[QualiBetPointsFields.q2_p11],
            q2_p12=source[QualiBetPointsFields.q2_p12],
            q2_p13=source[QualiBetPointsFields.q2_p13],
            q2_p14=source[QualiBetPointsFields.q2_p14],
            q2_p15=source[QualiBetPointsFields.q2_p15],
            q1_p16=source[QualiBetPointsFields.q1_p16],
            q1_p17=source[QualiBetPointsFields.q1_p17],
            q1_p18=source[QualiBetPointsFields.q1_p18],
            q1_p19=source[QualiBetPointsFields.q1_p19],
            q1_p20=source[QualiBetPointsFields.q1_p20],
            q3=source[QualiBetPointsFields.total_q3],
            q2=source[QualiBetPointsFields.total_q2],
            q1=source[QualiBetPointsFields.total_q1],
            q3_multiplier=source[QualiBetPointsFields.q3_multiplier],
            q2_multiplier=source[QualiBetPointsFields.q2_multiplier],
            q1_multiplier=source[QualiBetPointsFields.q1_multiplier],
            total=source[QualiBetPointsFields.total],
            multiplier=source[QualiBetPointsFields.multiplier],
        )

    def to_dict(self):
        return {
            QualiBetPointsFields.q3_p1: self.q3_p1,
            QualiBetPointsFields.q3_p2: self.q3_p2,
            QualiBetPointsFields.q3_p3: self.q3_p3,
            QualiBetPointsFields.q3_p4: self.q3_p4,
            QualiBetPointsFields.q3_p5: self.q3_p5,
            QualiBetPointsFields.q3_p6: self.q3_p6,
            QualiBetPointsFields.q3_p7: self.q3_p7,
            QualiBetPointsFields.q3_p8: self.q3_p8,
            QualiBetPointsFields.q3_p9: self.q3_p9,
            QualiBetPointsFields.q3_p10: self.q3_p10,
            QualiBetPointsFields.q2_p11: self.q2_p11,
            QualiBetPointsFields.q2_p12: self.q2_p12,
            QualiBetPointsFields.q2_p13: self.q2_p13,
            QualiBetPointsFields.q2_p14: self.q2_p14,
            QualiBetPointsFields.q2_p15: self.q2_p15,
            QualiBetPointsFields.q1_p16: self.q1_p16,
            QualiBetPointsFields.q1_p17: self.q1_p17,
            QualiBetPointsFields.q1_p18: self.q1_p18,
            QualiBetPointsFields.q1_p19: self.q1_p19,
            QualiBetPointsFields.q1_p20: self.q1_p20,
            QualiBetPointsFields.total_q3: self.q3,
            QualiBetPointsFields.total_q2: self.q2,
            QualiBetPointsFields.total_q1: self.q1,
            QualiBetPointsFields.q3_multiplier: self.q3_multiplier,
            QualiBetPointsFields.q2_multiplier: self.q2_multiplier,
            QualiBetPointsFields.q1_multiplier: self.q1_multiplier,
            QualiBetPointsFields.total: self.total,
            QualiBetPointsFields.multiplier: self.multiplier,
        }


class QualiBetPointsFields:
    q3_p1 = 'q3P1'
    q3_p2 = 'q3P2'
    q3_p3 = 'q3P3'
    q3_p4 = 'q3P4'
    q3_p5 = 'q3P5'
    q3_p6 = 'q3P6'
    q3_p7 = 'q3P7'
    q3_p8 = 'q3P8'
    q3_p9 = 'q3P9'
    q3_p10 = 'q3P10'
    q2_p11 = 'q2P11'
    q2_p12 = 'q2P12'
    q2_p13 = 'q2P13'
    q2_p14 = 'q2P14'
    q2_p15 = 'q2P15'
    q1_p16 = 'q1P16'
    q1_p17 = 'q1P17'
    q1_p18 = 'q1P18'
    q1_p19 = 'q1P19'
    q1_p20 = 'q1P20'
    total_q3 = 'totalQ3'
    total_q2 = 'totalQ2'
    total_q1 = 'totalQ1'
    q3_multiplier = 'q3Multiplier'
    q2_multiplier = 'q2Multiplier'
    q1_multiplier = 'q1Multiplier'
    total = 'total'
    multiplier = 'multiplier'
