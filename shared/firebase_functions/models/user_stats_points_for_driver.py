from pydantic import BaseModel


class UserStatsPointsForDriver(BaseModel):
    season_driver_id: str
    points: float

    @staticmethod
    def from_dict(source):
        return UserStatsPointsForDriver(
            season_driver_id=source[UserStatsPointsForDriverFields.SEASON_DRIVER_ID],
            points=source[UserStatsPointsForDriverFields.POINTS],
        )

    def to_dict(self):
        return {
            UserStatsPointsForDriverFields.SEASON_DRIVER_ID: self.season_driver_id,
            UserStatsPointsForDriverFields.POINTS: self.points,
        }


class UserStatsPointsForDriverFields:
    SEASON_DRIVER_ID = 'seasonDriverId'
    POINTS = 'points'
