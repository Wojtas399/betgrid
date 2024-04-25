from pydantic import BaseModel
from typing import List, Optional

class GrandPrixResults(BaseModel):
    grandPrixId: str
    qualiStandingsByDriverIds: Optional[List[str]]
    p1DriverId: Optional[str]
    p2DriverId: Optional[str]
    p3DriverId: Optional[str]
    p10DriverId: Optional[str]
    fastestLapDriverId: Optional[str]
    dnfDriverIds: Optional[List[str]]
    wasThereSafetyCar: Optional[bool]
    wasThereRedFlag: Optional[bool]

    @staticmethod
    def from_dict(source):
        return GrandPrixResults(
            grandPrixId=source['grandPrixId'],
            qualiStandingsByDriverIds=source['qualiStandingsByDriverIds'],
            p1DriverId=source['p1DriverId'],
            p2DriverId=source['p2DriverId'],
            p3DriverId=source['p3DriverId'],
            p10DriverId=source['p10DriverId'],
            fastestLapDriverId=source['fastestLapDriverId'],
            dnfDriverIds=source['dnfDriverIds'],
            wasThereSafetyCar=source['wasThereSafetyCar'],
            wasThereRedFlag=source['wasThereRedFlag'],
        )
