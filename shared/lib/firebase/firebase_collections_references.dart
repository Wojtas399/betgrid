import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_collections.dart';
import 'model/driver_personal_data_dto.dart';
import 'model/grand_prix_basic_info_dto.dart';
import 'model/season_grand_prix_bet_dto.dart';
import 'model/season_grand_prix_bet_points_dto.dart';
import 'model/season_driver_dto.dart';
import 'model/season_grand_prix_dto.dart';
import 'model/season_grand_prix_results_dto.dart';
import 'model/season_team_dto.dart';
import 'model/user_dto.dart';
import 'model/user_stats_dto.dart';

class FirebaseCollectionsReferences {
  final _firebaseCollections = FirebaseCollections();

  CollectionReference<DriverPersonalDataDto> driversPersonalData() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.driversPersonalData)
        .withConverter<DriverPersonalDataDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'DriverPersonalData document data is null';
            return DriverPersonalDataDto.fromFirestore(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (DriverPersonalDataDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<GrandPrixBasicInfoDto> grandPrixesBasicInfo() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.grandPrixesBasicInfo)
        .withConverter<GrandPrixBasicInfoDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'GrandPrixBasicInfo document does not exist';
            }
            return GrandPrixBasicInfoDto.fromFirestore(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (GrandPrixBasicInfoDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<SeasonDriverDto> seasonDrivers(int season) {
    return _season(season)
        .collection(_firebaseCollections.season.drivers)
        .withConverter<SeasonDriverDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'SeasonDriver document does not exist';
            }
            return SeasonDriverDto.fromFirestore(
              id: snapshot.id,
              season: season,
              json: data,
            );
          },
          toFirestore: (SeasonDriverDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<SeasonGrandPrixDto> seasonGrandPrixes(int season) {
    return _season(season)
        .collection(_firebaseCollections.season.grandPrixes)
        .withConverter<SeasonGrandPrixDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'SeasonGrandPrix document does not exist';
            return SeasonGrandPrixDto.fromFirestore(
              id: snapshot.id,
              season: season,
              json: data,
            );
          },
          toFirestore: (SeasonGrandPrixDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<SeasonGrandPrixResultsDto> seasonGrandPrixesResults(
    int season,
  ) {
    return _season(season)
        .collection(_firebaseCollections.season.grandPrixesResults)
        .withConverter<SeasonGrandPrixResultsDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'SeasonGrandPrixResults document does not exist';
            }
            return SeasonGrandPrixResultsDto.fromFirestore(
              id: snapshot.id,
              season: season,
              json: data,
            );
          },
          toFirestore: (SeasonGrandPrixResultsDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<SeasonTeamDto> seasonTeams(int season) {
    return _season(season)
        .collection(_firebaseCollections.season.teams)
        .withConverter<SeasonTeamDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'SeasonTeam document does not exist';
            }
            return SeasonTeamDto.fromFirestore(
              id: snapshot.id,
              season: season,
              json: data,
            );
          },
          toFirestore: (SeasonTeamDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<UserDto> users() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.users.main)
        .withConverter<UserDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'User document does not exist';
            }
            return UserDto.fromFirestore(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (UserDto dto, _) => dto.toFirestore(),
        );
  }

  CollectionReference<SeasonGrandPrixBetDto> seasonGrandPrixesBets({
    required String userId,
    required int season,
  }) =>
      _userSeason(userId, season)
          .collection(_firebaseCollections.users.season.grandPrixesBets)
          .withConverter<SeasonGrandPrixBetDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) throw 'SeasonGrandPrixBet document was null';
              return SeasonGrandPrixBetDto.fromFirestore(
                id: snapshot.id,
                userId: userId,
                season: season,
                json: data,
              );
            },
            toFirestore: (SeasonGrandPrixBetDto dto, _) => dto.toFirestore(),
          );

  CollectionReference<SeasonGrandPrixBetPointsDto> seasonGrandPrixesBetPoints({
    required String userId,
    required int season,
  }) =>
      _userSeason(userId, season)
          .collection(_firebaseCollections.users.season.grandPrixesBetPoints)
          .withConverter<SeasonGrandPrixBetPointsDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) {
                throw 'SeasonGrandPrixBetPoints document was null';
              }
              return SeasonGrandPrixBetPointsDto.fromFirestore(
                id: snapshot.id,
                userId: userId,
                season: season,
                json: data,
              );
            },
            toFirestore: (SeasonGrandPrixBetPointsDto dto, _) =>
                dto.toFirestore(),
          );

  DocumentReference<UserStatsDto> userStats({
    required String userId,
    required int season,
  }) =>
      _userSeason(userId, season).withConverter<UserStatsDto>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) throw 'User stats document was null';
          return UserStatsDto.fromFirestore(
            userId: userId,
            season: season,
            json: data,
          );
        },
        toFirestore: (UserStatsDto dto, _) => dto.toFirestore(),
      );

  DocumentReference<dynamic> _season(int season) {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.season.main)
        .doc(season.toString());
  }

  DocumentReference<dynamic> _userSeason(String userId, int season) {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.users.main)
        .doc(userId)
        .collection(_firebaseCollections.users.season.main)
        .doc(season.toString());
  }
}
