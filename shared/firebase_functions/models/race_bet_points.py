class RaceBetPoints:
    def __init__(
        self,
        p1: float,
        p2: float,
        p3: float,
        p10: float,
        fastest_lap: float,
        dnf_driver1: float,
        dnf_driver2: float,
        dnf_driver3: float,
        safety_car: float,
        red_flag: float,
        podium_and_p10: float,
        podium_and_p10_multiplier: float | None,
        total_dnf: float,
        dnf_multiplier: float | None,
        safety_car_and_red_flag: float,
        total: float,
    ):
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        self.p10 = p10
        self.fastest_lap = fastest_lap
        self.dnf_driver1 = dnf_driver1
        self.dnf_driver2 = dnf_driver2
        self.dnf_driver3 = dnf_driver3
        self.safety_car = safety_car
        self.red_flag = red_flag
        self.podium_and_p10 = podium_and_p10
        self.podium_and_p10_multiplier = podium_and_p10_multiplier
        self.total_dnf = total_dnf
        self.dnf_multiplier = dnf_multiplier
        self.safety_car_and_red_flag = safety_car_and_red_flag
        self.total = total

    @staticmethod
    def from_dict(source):
        return RaceBetPoints(
            p1=source[RaceBetPointsFields.p1],
            p2=source[RaceBetPointsFields.p2],
            p3=source[RaceBetPointsFields.p3],
            p10=source[RaceBetPointsFields.p10],
            fastest_lap=source[RaceBetPointsFields.fastest_lap],
            dnf_driver1=source[RaceBetPointsFields.dnf_driver1],
            dnf_driver2=source[RaceBetPointsFields.dnf_driver2],
            dnf_driver3=source[RaceBetPointsFields.dnf_driver3],
            safety_car=source[RaceBetPointsFields.safety_car],
            red_flag=source[RaceBetPointsFields.red_flag],
            podium_and_p10=source[RaceBetPointsFields.podium_and_p10],
            podium_and_p10_multiplier=source[RaceBetPointsFields.podium_and_p10_multiplier],
            total_dnf=source[RaceBetPointsFields.total_dnf],
            dnf_multiplier=source[RaceBetPointsFields.dnf_multiplier],
            safety_car_and_red_flag=source[RaceBetPointsFields.safety_car_and_red_flag],
            total=source[RaceBetPointsFields.total],
        )

    def to_dict(self):
        return {
            RaceBetPointsFields.p1: self.p1,
            RaceBetPointsFields.p2: self.p2,
            RaceBetPointsFields.p3: self.p3,
            RaceBetPointsFields.p10: self.p10,
            RaceBetPointsFields.fastest_lap: self.fastest_lap,
            RaceBetPointsFields.dnf_driver1: self.dnf_driver1,
            RaceBetPointsFields.dnf_driver2: self.dnf_driver2,
            RaceBetPointsFields.dnf_driver3: self.dnf_driver3,
            RaceBetPointsFields.safety_car: self.safety_car,
            RaceBetPointsFields.red_flag: self.red_flag,
            RaceBetPointsFields.podium_and_p10: self.podium_and_p10,
            RaceBetPointsFields.podium_and_p10_multiplier: self.podium_and_p10_multiplier,
            RaceBetPointsFields.total_dnf: self.total_dnf,
            RaceBetPointsFields.dnf_multiplier: self.dnf_multiplier,
            RaceBetPointsFields.safety_car_and_red_flag: self.safety_car_and_red_flag,
            RaceBetPointsFields.total: self.total,
        }


class RaceBetPointsFields:
    p1 = 'p1'
    p2 = 'p2'
    p3 = 'p3'
    p10 = 'p10'
    fastest_lap = 'fastestLap'
    dnf_driver1 = 'dnfDriver1'
    dnf_driver2 = 'dnfDriver2'
    dnf_driver3 = 'dnfDriver3'
    safety_car = 'safetyCar'
    red_flag = 'redFlag'
    podium_and_p10 = 'podiumAndP10'
    podium_and_p10_multiplier = 'podiumAndP10Multiplier'
    total_dnf = 'totalDnf'
    dnf_multiplier = 'dnfMultiplier'
    safety_car_and_red_flag = 'safetyCarAndRedFlag'
    total = 'total'
