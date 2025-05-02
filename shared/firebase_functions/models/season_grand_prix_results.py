from typing import List, Optional
from pydantic import BaseModel


class SeasonGrandPrixResults(BaseModel):
    season_grand_prix_id: str
    quali_standings_by_season_driver_ids: Optional[List[str]]
    p1_season_driver_id: Optional[str]
    p2_season_driver_id: Optional[str]
    p3_season_driver_id: Optional[str]
    p10_season_driver_id: Optional[str]
    fastest_lap_season_driver_id: Optional[str]
    dnf_season_driver_ids: Optional[List[str]]
    was_there_safety_car: Optional[bool]
    was_there_red_flag: Optional[bool]

    @staticmethod
    def from_dict(source):
        return SeasonGrandPrixResults(
            season_grand_prix_id=source[SeasonGrandPrixResultsFields.season_grand_prix_id],
            quali_standings_by_season_driver_ids=source[
                SeasonGrandPrixResultsFields.quali_standings_by_season_driver_ids],
            p1_season_driver_id=source[SeasonGrandPrixResultsFields.p1_season_driver_id],
            p2_season_driver_id=source[SeasonGrandPrixResultsFields.p2_season_driver_id],
            p3_season_driver_id=source[SeasonGrandPrixResultsFields.p3_season_driver_id],
            p10_season_driver_id=source[SeasonGrandPrixResultsFields.p10_season_driver_id],
            fastest_lap_season_driver_id=source[SeasonGrandPrixResultsFields.fastest_lap_season_driver_id],
            dnf_season_driver_ids=source[SeasonGrandPrixResultsFields.dnf_season_driver_ids],
            was_there_safety_car=source[SeasonGrandPrixResultsFields.was_there_safety_car],
            was_there_red_flag=source[SeasonGrandPrixResultsFields.was_there_red_flag],
        )

    def to_dict(self):
        return {
            SeasonGrandPrixResultsFields.season_grand_prix_id: self.season_grand_prix_id,
            SeasonGrandPrixResultsFields.quali_standings_by_season_driver_ids: self.quali_standings_by_season_driver_ids,
            SeasonGrandPrixResultsFields.p1_season_driver_id: self.p1_season_driver_id,
            SeasonGrandPrixResultsFields.p2_season_driver_id: self.p2_season_driver_id,
            SeasonGrandPrixResultsFields.p3_season_driver_id: self.p3_season_driver_id,
            SeasonGrandPrixResultsFields.p10_season_driver_id: self.p10_season_driver_id,
            SeasonGrandPrixResultsFields.fastest_lap_season_driver_id: self.fastest_lap_season_driver_id,
            SeasonGrandPrixResultsFields.dnf_season_driver_ids: self.dnf_season_driver_ids,
            SeasonGrandPrixResultsFields.was_there_safety_car: self.was_there_safety_car,
            SeasonGrandPrixResultsFields.was_there_red_flag: self.was_there_red_flag,
        }


class SeasonGrandPrixResultsFields:
    season_grand_prix_id = 'seasonGrandPrixId'
    quali_standings_by_season_driver_ids = 'qualiStandingsBySeasonDriverIds'
    p1_season_driver_id = 'p1SeasonDriverId'
    p2_season_driver_id = 'p2SeasonDriverId'
    p3_season_driver_id = 'p3SeasonDriverId'
    p10_season_driver_id = 'p10SeasonDriverId'
    fastest_lap_season_driver_id = 'fastestLapSeasonDriverId'
    dnf_season_driver_ids = 'dnfSeasonDriverIds'
    was_there_safety_car = 'wasThereSafetyCar'
    was_there_red_flag = 'wasThereRedFlag'
