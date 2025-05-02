from pydantic import BaseModel


class UserStatsPointsForSeasonGp(BaseModel):
    season_grand_prix_id: str
    points: float

    @staticmethod
    def from_dict(source):
        return UserStatsPointsForSeasonGp(
            season_grand_prix_id=source[
                UserStatsPointsForSeasonGpFields.SEASON_GRAND_PRIX_ID
            ],
            points=source[UserStatsPointsForSeasonGpFields.POINTS],
        )

    def to_dict(self):
        return {
            UserStatsPointsForSeasonGpFields.SEASON_GRAND_PRIX_ID: self.season_grand_prix_id,
            UserStatsPointsForSeasonGpFields.POINTS: self.points,
        }


class UserStatsPointsForSeasonGpFields:
    SEASON_GRAND_PRIX_ID = 'seasonGrandPrixId'
    POINTS = 'points'
