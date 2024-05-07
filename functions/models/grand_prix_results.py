from pydantic import BaseModel
from typing import List, Optional

class GrandPrixResults(BaseModel):
    grand_prix_id: str
    quali_standings_by_driver_ids: Optional[List[str]]
    p1_driver_id: Optional[str]
    p2_driver_id: Optional[str]
    p3_driver_id: Optional[str]
    p10_driver_id: Optional[str]
    fastest_lap_driver_id: Optional[str]
    dnf_driver_ids: Optional[List[str]]
    was_there_safety_car: Optional[bool]
    was_there_red_flag: Optional[bool]

    @staticmethod
    def from_dict(source):
        return GrandPrixResults(
            grand_prix_id=source['grandPrixId'],
            quali_standings_by_driver_ids=source['qualiStandingsByDriverIds'],
            p1_driver_id=source['p1DriverId'],
            p2_driver_id=source['p2DriverId'],
            p3_driver_id=source['p3DriverId'],
            p10_driver_id=source['p10DriverId'],
            fastest_lap_driver_id=source['fastestLapDriverId'],
            dnf_driver_ids=source['dnfDriverIds'],
            was_there_safety_car=source['wasThereSafetyCar'],
            was_there_red_flag=source['wasThereRedFlag'],
        )
    
    def to_dict(self):
        return {
            'grandPrixId': self.grand_prix_id,
            'qualiStandingsByDriverIds': self.quali_standings_by_driver_ids,
            'p1DriverId': self.p1_driver_id,
            'p2DriverId': self.p2_driver_id,
            'p3DriverId': self.p3_driver_id,
            'p10DriverId': self.p10_driver_id,
            'fastestLapDriverId': self.fastest_lap_driver_id,
            'dnfDriverIds': self.dnf_driver_ids,
            'wasThereSafetyCar': self.was_there_safety_car,
            'wasThereRedFlag': self.was_there_red_flag,
        }
