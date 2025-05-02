from .quali_bet_points import QualiBetPoints
from .race_bet_points import RaceBetPoints


class SeasonGrandPrixBetPoints:
    def __init__(
        self,
        season_grand_prix_id: str,
        total: float,
        quali: QualiBetPoints | None,
        race: RaceBetPoints | None,
    ):
        self.season_grand_prix_id = season_grand_prix_id
        self.total = total
        self.quali = quali
        self.race = race

    @staticmethod
    def from_dict(source):
        return SeasonGrandPrixBetPoints(
            season_grand_prix_id=source[SeasonGrandPrixBetPointsFields.season_grand_prix_id],
            total=source[SeasonGrandPrixBetPointsFields.total],
            quali=(
                QualiBetPoints.from_dict(
                    source[SeasonGrandPrixBetPointsFields.quali])
                if source[SeasonGrandPrixBetPointsFields.quali] is not None
                else None
            ),
            race=(
                RaceBetPoints.from_dict(
                    source[SeasonGrandPrixBetPointsFields.race])
                if source[SeasonGrandPrixBetPointsFields.race] is not None
                else None
            ),
        )

    def to_dict(self):
        return {
            SeasonGrandPrixBetPointsFields.season_grand_prix_id: self.season_grand_prix_id,
            SeasonGrandPrixBetPointsFields.total: self.total,
            SeasonGrandPrixBetPointsFields.quali: (
                self.quali.to_dict()
                if self.quali is not None
                else None
            ),
            SeasonGrandPrixBetPointsFields.race: (
                self.race.to_dict()
                if self.race is not None
                else None
            ),
        }


class SeasonGrandPrixBetPointsFields:
    season_grand_prix_id = 'seasonGrandPrixId'
    total = 'total'
    quali = 'quali'
    race = 'race'
