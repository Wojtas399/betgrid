from typing import List
from pydantic import BaseModel


class SeasonGrandPrixBet(BaseModel):
    season_grand_prix_id: str
    quali_standings_by_season_driver_ids: List[str | None] | None
    p1_season_driver_id: str | None
    p2_season_driver_id: str | None
    p3_season_driver_id: str | None
    p10_season_driver_id: str | None
    fastest_lap_season_driver_id: str | None
    dnf_season_driver_ids: List[str] | None
    will_be_safety_car: bool | None
    will_be_red_flag: bool | None

    @staticmethod
    def from_dict(source):
        return SeasonGrandPrixBet(
            season_grand_prix_id=source[SeasonGrandPrixBetFields.season_grand_prix_id],
            quali_standings_by_season_driver_ids=source[
                SeasonGrandPrixBetFields.quali_standings_by_season_driver_ids],
            p1_season_driver_id=source[SeasonGrandPrixBetFields.p1_season_driver_id],
            p2_season_driver_id=source[SeasonGrandPrixBetFields.p2_season_driver_id],
            p3_season_driver_id=source[SeasonGrandPrixBetFields.p3_season_driver_id],
            p10_season_driver_id=source[SeasonGrandPrixBetFields.p10_season_driver_id],
            fastest_lap_season_driver_id=source[
                SeasonGrandPrixBetFields.fastest_lap_season_driver_id],
            dnf_season_driver_ids=source[SeasonGrandPrixBetFields.dnf_season_driver_ids],
            will_be_safety_car=source[SeasonGrandPrixBetFields.will_be_safety_car],
            will_be_red_flag=source[SeasonGrandPrixBetFields.will_be_red_flag],
        )

    def to_dict(self):
        return {
            SeasonGrandPrixBetFields.season_grand_prix_id: self.season_grand_prix_id,
            SeasonGrandPrixBetFields.quali_standings_by_season_driver_ids: self.quali_standings_by_season_driver_ids,
            SeasonGrandPrixBetFields.p1_season_driver_id: self.p1_season_driver_id,
            SeasonGrandPrixBetFields.p2_season_driver_id: self.p2_season_driver_id,
            SeasonGrandPrixBetFields.p3_season_driver_id: self.p3_season_driver_id,
            SeasonGrandPrixBetFields.p10_season_driver_id: self.p10_season_driver_id,
            SeasonGrandPrixBetFields.fastest_lap_season_driver_id: self.fastest_lap_season_driver_id,
            SeasonGrandPrixBetFields.dnf_season_driver_ids: self.dnf_season_driver_ids,
            SeasonGrandPrixBetFields.will_be_safety_car: self.will_be_safety_car,
            SeasonGrandPrixBetFields.will_be_red_flag: self.will_be_red_flag,
        }


class SeasonGrandPrixBetFields:
    season_grand_prix_id = 'seasonGrandPrixId'
    quali_standings_by_season_driver_ids = 'qualiStandingsBySeasonDriverIds'
    p1_season_driver_id = 'p1SeasonDriverId'
    p2_season_driver_id = 'p2SeasonDriverId'
    p3_season_driver_id = 'p3SeasonDriverId'
    p10_season_driver_id = 'p10SeasonDriverId'
    fastest_lap_season_driver_id = 'fastestLapSeasonDriverId'
    dnf_season_driver_ids = 'dnfSeasonDriverIds'
    will_be_safety_car = 'willBeSafetyCar'
    will_be_red_flag = 'willBeRedFlag'
