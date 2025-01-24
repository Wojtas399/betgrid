from pydantic import BaseModel
from typing import List
from .player_stats_points_for_gp import PlayerStatsPointsForGp
from .player_stats_points_for_driver import PlayerStatsPointsForDriver

class PlayerStats(BaseModel):
    best_gp_points: PlayerStatsPointsForGp
    best_quali_points: PlayerStatsPointsForGp
    best_race_points: PlayerStatsPointsForGp
    points_for_drivers: List[PlayerStatsPointsForDriver]
    
    @staticmethod
    def from_dict(source):
        return PlayerStats(
            best_gp_points = source['bestGpPoints'],
            best_quali_points = source['bestQualiPoints'],
            best_race_points = source['bestRacePoints'],
            points_for_drivers = source['pointsForDrivers'],
        )
    
    def to_dict(self):
        return {
            'bestGpPoints': self.best_gp_points.to_dict(),
            'bestQualiPoints': self.best_quali_points.to_dict(),
            'bestRacePoints': self.best_race_points.to_dict(),
            'pointsForDrivers': [
                driver.to_dict() for driver in self.points_for_drivers
                ],
        }