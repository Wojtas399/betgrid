from typing import List
from google.cloud.firestore import Client
from models import (
    SeasonGrandPrixBet,
    SeasonGrandPrixBetPoints,
    RaceBetPoints,
    UserStats,
    UserStatsPointsForSeasonGp,
    UserStatsPointsForDriver,
)
from service.data import (
    UserStatsDataService,
    SeasonDriverDataService,
    SeasonGrandPrixBetPointsDataService,
    SeasonGrandPrixBetDataService,
)


class UserStatsService:
    def __init__(self, db_client: Client):
        self.user_stats_data_service = UserStatsDataService(db_client)
        self.season_driver_data_service = SeasonDriverDataService(db_client)
        self.season_grand_prix_bet_points_data_service = (
            SeasonGrandPrixBetPointsDataService(db_client)
        )
        self.season_grand_prix_bet_data_service = (
            SeasonGrandPrixBetDataService(db_client)
        )

    def calculate_stats_for_user_season(
        self,
        user_id: str,
        season: int,
    ):
        points_for_season_gp_bets: List[SeasonGrandPrixBetPoints] = (
            self.season_grand_prix_bet_points_data_service.load_all_from_season(
                user_id=user_id,
                season=season,
            )
        )

        if not points_for_season_gp_bets:
            return

        best_gp_points = self.__find_best_gp_points(
            season_grand_prixes_bets_points=points_for_season_gp_bets,
        )
        best_quali_points = self.__find_best_quali_points(
            season_grand_prixes_bets_points=points_for_season_gp_bets,
        )
        best_race_points = self.__find_best_race_points(
            season_grand_prixes_bets_points=points_for_season_gp_bets,
        )
        points_for_drivers = self.__create_points_for_drivers(
            user_id=user_id,
            season=season,
            season_grand_prixes_bets_points=points_for_season_gp_bets,
        )
        total_points = sum(
            bet_points.total for bet_points in points_for_season_gp_bets
        )

        self.user_stats_data_service.update_for_user_and_season(
            user_id=user_id,
            season=season,
            updated_user_stats=UserStats(
                best_gp_points=best_gp_points,
                best_quali_points=best_quali_points,
                best_race_points=best_race_points,
                points_for_drivers=points_for_drivers,
                total_points=total_points,
            ),
        )

    def __find_best_gp_points(
        self,
        season_grand_prixes_bets_points: List[SeasonGrandPrixBetPoints]
    ) -> UserStatsPointsForSeasonGp:
        season_gp_bets_points_with_best_total = max(
            season_grand_prixes_bets_points,
            key=lambda x: x.total,
        )
        return UserStatsPointsForSeasonGp(
            season_grand_prix_id=season_gp_bets_points_with_best_total.season_grand_prix_id,
            points=season_gp_bets_points_with_best_total.total,
        )

    def __find_best_quali_points(
        self,
        season_grand_prixes_bets_points: List[SeasonGrandPrixBetPoints]
    ) -> UserStatsPointsForSeasonGp | None:
        season_gp_bets_points_with_best_quali = max(
            season_grand_prixes_bets_points,
            key=lambda x: x.quali.total if x.quali is not None else 0.0,
        )
        return UserStatsPointsForSeasonGp(
            season_grand_prix_id=season_gp_bets_points_with_best_quali.season_grand_prix_id,
            points=season_gp_bets_points_with_best_quali.quali.total,
        ) if season_gp_bets_points_with_best_quali.quali is not None else None

    def __find_best_race_points(
        self,
        season_grand_prixes_bets_points: List[SeasonGrandPrixBetPoints]
    ) -> UserStatsPointsForSeasonGp | None:
        season_gp_bets_points_with_best_race = max(
            season_grand_prixes_bets_points,
            key=lambda x: x.race.total if x.race is not None else 0.0,
        )
        return UserStatsPointsForSeasonGp(
            season_grand_prix_id=season_gp_bets_points_with_best_race.season_grand_prix_id,
            points=season_gp_bets_points_with_best_race.race.total,
        ) if season_gp_bets_points_with_best_race.race is not None else None

    def __create_points_for_drivers(
        self,
        user_id: str,
        season: int,
        season_grand_prixes_bets_points: List[SeasonGrandPrixBetPoints]
    ):
        all_season_drivers_ids = (
            self.season_driver_data_service.load_ids_of_all_drivers_from_season(
                season=season,
            )
        )

        points_for_drivers = []

        for season_driver_id in all_season_drivers_ids:
            total_points_for_driver = 0.0

            for season_gp_bet_points in season_grand_prixes_bets_points:
                season_gp_bet = (
                    self.season_grand_prix_bet_data_service.load_for_season_grand_prix(
                        user_id=user_id,
                        season=season,
                        season_grand_prix_id=season_gp_bet_points.season_grand_prix_id,
                    )
                )
                points_for_season_gp_bet = self.__get_points_for_driver(
                    season_driver_id=season_driver_id,
                    season_gp_bet=season_gp_bet,
                    season_gp_bet_points=season_gp_bet_points,
                ) if season_gp_bet is not None else 0.0
                total_points_for_driver += points_for_season_gp_bet

            points_for_drivers.append(
                UserStatsPointsForDriver(
                    season_driver_id=season_driver_id,
                    points=total_points_for_driver,
                )
            )

        return points_for_drivers

    def __get_points_for_driver(
        self,
        season_driver_id: str,
        season_gp_bet: SeasonGrandPrixBet,
        season_gp_bet_points: SeasonGrandPrixBetPoints,
    ):
        points_for_quali = self.__get_points_for_season_driver_for_quali(
            season_driver_id=season_driver_id,
            quali_standings_by_season_driver_ids=season_gp_bet.quali_standings_by_season_driver_ids,
            season_gp_bet_points=season_gp_bet_points,
        ) if season_gp_bet_points.quali is not None else 0.0
        points_for_race = self.__get_points_for_season_driver_for_race(
            season_driver_id=season_driver_id,
            season_gp_bet=season_gp_bet,
            race_points=season_gp_bet_points.race,
        ) if season_gp_bet_points.race is not None else 0.0
        return points_for_quali + points_for_race

    def __get_points_for_season_driver_for_quali(
        self,
        season_driver_id: str,
        quali_standings_by_season_driver_ids: List[str],
        season_gp_bet_points: SeasonGrandPrixBetPoints,
    ):
        if season_driver_id not in quali_standings_by_season_driver_ids:
            return 0.0

        position_index_in_quali = quali_standings_by_season_driver_ids.index(
            season_driver_id
        )
        return [
            season_gp_bet_points.quali.q3_p1,
            season_gp_bet_points.quali.q3_p2,
            season_gp_bet_points.quali.q3_p3,
            season_gp_bet_points.quali.q3_p4,
            season_gp_bet_points.quali.q3_p5,
            season_gp_bet_points.quali.q3_p6,
            season_gp_bet_points.quali.q3_p7,
            season_gp_bet_points.quali.q3_p8,
            season_gp_bet_points.quali.q3_p9,
            season_gp_bet_points.quali.q3_p10,
            season_gp_bet_points.quali.q2_p11,
            season_gp_bet_points.quali.q2_p12,
            season_gp_bet_points.quali.q2_p13,
            season_gp_bet_points.quali.q2_p14,
            season_gp_bet_points.quali.q2_p15,
            season_gp_bet_points.quali.q1_p16,
            season_gp_bet_points.quali.q1_p17,
            season_gp_bet_points.quali.q1_p18,
            season_gp_bet_points.quali.q1_p19,
            season_gp_bet_points.quali.q1_p20,
        ][position_index_in_quali]

    def __get_points_for_season_driver_for_race(
        self,
        season_driver_id: str,
        season_gp_bet: SeasonGrandPrixBet,
        race_points: RaceBetPoints,
    ):
        points_for_race = 0.0

        if season_gp_bet.p1_season_driver_id == season_driver_id:
            points_for_race = race_points.p1
        elif season_gp_bet.p2_season_driver_id == season_driver_id:
            points_for_race = race_points.p2
        elif season_gp_bet.p3_season_driver_id == season_driver_id:
            points_for_race = race_points.p3
        elif season_gp_bet.p10_season_driver_id == season_driver_id:
            points_for_race = race_points.p10

        if season_gp_bet.fastest_lap_season_driver_id == season_driver_id:
            points_for_race += race_points.fastest_lap

        dnf_drivers = season_gp_bet.dnf_season_driver_ids
        if season_driver_id in dnf_drivers:
            dnf_index = dnf_drivers.index(season_driver_id)
            if dnf_index == 0:
                points_for_race += race_points.dnf_driver1
            elif dnf_index == 1:
                points_for_race += race_points.dnf_driver2
            elif dnf_index == 2:
                points_for_race += race_points.dnf_driver3

        return points_for_race
