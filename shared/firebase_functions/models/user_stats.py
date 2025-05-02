from typing import List
from pydantic import BaseModel
from .user_stats_points_for_season_gp import UserStatsPointsForSeasonGp
from .user_stats_points_for_driver import UserStatsPointsForDriver


class UserStats(BaseModel):
    best_gp_points: UserStatsPointsForSeasonGp | None
    best_quali_points: UserStatsPointsForSeasonGp | None
    best_race_points: UserStatsPointsForSeasonGp | None
    points_for_drivers: List[UserStatsPointsForDriver] | None
    total_points: float

    @staticmethod
    def from_dict(source):
        return UserStats(
            best_gp_points=UserStatsPointsForSeasonGp.from_dict(
                source[UserStatsFields.BEST_GP_POINTS]
            ) if source[UserStatsFields.BEST_GP_POINTS] is not None else None,
            best_quali_points=UserStatsPointsForSeasonGp.from_dict(
                source[UserStatsFields.BEST_QUALI_POINTS]
            ) if source[UserStatsFields.BEST_QUALI_POINTS] is not None else None,
            best_race_points=UserStatsPointsForSeasonGp.from_dict(
                source[UserStatsFields.BEST_RACE_POINTS]
            ) if source[UserStatsFields.BEST_RACE_POINTS] is not None else None,
            points_for_drivers=[
                UserStatsPointsForDriver.from_dict(driver)
                for driver in source[UserStatsFields.POINTS_FOR_DRIVERS]
            ] if source[UserStatsFields.POINTS_FOR_DRIVERS] is not None else None,
            total_points=source[UserStatsFields.TOTAL_POINTS],
        )

    def to_dict(self):
        return {
            UserStatsFields.BEST_GP_POINTS: (
                self.best_gp_points.to_dict()
                if self.best_gp_points is not None
                else None
            ),
            UserStatsFields.BEST_QUALI_POINTS: (
                self.best_quali_points.to_dict()
                if self.best_quali_points is not None
                else None
            ),
            UserStatsFields.BEST_RACE_POINTS: (
                self.best_race_points.to_dict()
                if self.best_race_points is not None
                else None
            ),
            UserStatsFields.POINTS_FOR_DRIVERS: [
                driver.to_dict() for driver in self.points_for_drivers
            ] if self.points_for_drivers is not None else None,
            UserStatsFields.TOTAL_POINTS: self.total_points,
        }


class UserStatsFields:
    BEST_GP_POINTS = 'bestGpPoints'
    BEST_QUALI_POINTS = 'bestQualiPoints'
    BEST_RACE_POINTS = 'bestRacePoints'
    POINTS_FOR_DRIVERS = 'pointsForDrivers'
    TOTAL_POINTS = 'totalPoints'
