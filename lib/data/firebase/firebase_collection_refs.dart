import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'firebase_collections.dart';
import 'model/grand_prix_basic_info_dto.dart';
import 'model/grand_prix_bet_dto.dart';
import 'model/grand_prix_bet_points_dto.dart';
import 'model/grand_prix_results_dto.dart';
import 'model/season_driver_dto.dart';
import 'model/season_grand_prix_dto.dart';
import 'model/team_basic_info_dto.dart';
import 'model/user_dto.dart';
import 'model/player_stats_dto.dart';

@injectable
class FirebaseCollectionRefs {
  final FirebaseCollections _firebaseCollections;

  const FirebaseCollectionRefs(this._firebaseCollections);

  CollectionReference<GrandPrixBasicInfoDto> grandPrixesBasicInfo() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.grandPrixesBasicInfo)
        .withConverter<GrandPrixBasicInfoDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'There is not data of GrandPrixBasicInfo document';
            }
            return GrandPrixBasicInfoDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (GrandPrixBasicInfoDto dto, _) => dto.toJson(),
        );
  }

  CollectionReference<SeasonGrandPrixDto> seasonGrandPrixes() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.seasonGrandPrixes)
        .withConverter<SeasonGrandPrixDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'There is not data of SeasonGrandPrix document';
            }
            return SeasonGrandPrixDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (SeasonGrandPrixDto dto, _) => dto.toJson(),
        );
  }

  CollectionReference<GrandPrixResultsDto> grandPrixesResults() =>
      FirebaseFirestore.instance
          .collection(_firebaseCollections.grandPrixesResults)
          .withConverter<GrandPrixResultsDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) {
                throw 'Grand prix result document data was null';
              }
              return GrandPrixResultsDto.fromFirebase(
                id: snapshot.id,
                json: data,
              );
            },
            toFirestore: (GrandPrixResultsDto dto, _) => dto.toJson(),
          );

  CollectionReference<UserDto> users() => FirebaseFirestore.instance
      .collection(_firebaseCollections.users.main)
      .withConverter<UserDto>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) throw 'User document data was null';
          return UserDto.fromFirebase(
            id: snapshot.id,
            json: data,
          );
        },
        toFirestore: (UserDto dto, _) => dto.toJson(),
      );

  CollectionReference<GrandPrixBetDto> grandPrixesBets(String userId) =>
      FirebaseFirestore.instance
          .collection(_firebaseCollections.users.main)
          .doc(userId)
          .collection(_firebaseCollections.users.grandPrixesBets)
          .withConverter<GrandPrixBetDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) throw 'Grand prix bet document was null';
              return GrandPrixBetDto.fromFirebase(
                id: snapshot.id,
                playerId: userId,
                json: data,
              );
            },
            toFirestore: (GrandPrixBetDto dto, _) => dto.toJson(),
          );

  CollectionReference<GrandPrixBetPointsDto> grandPrixesBetPoints(
    String userId,
  ) =>
      FirebaseFirestore.instance
          .collection(_firebaseCollections.users.main)
          .doc(userId)
          .collection(_firebaseCollections.users.grandPrixesBetPoints)
          .withConverter<GrandPrixBetPointsDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) throw 'Grand prix bet points document was null';
              return GrandPrixBetPointsDto.fromFirebase(
                id: snapshot.id,
                playerId: userId,
                json: data,
              );
            },
            toFirestore: (GrandPrixBetPointsDto dto, _) => dto.toJson(),
          );

  CollectionReference<SeasonDriverDto> seasonDrivers() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.seasonDrivers)
        .withConverter<SeasonDriverDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'Season driver_personal_data document is null';
            }
            return SeasonDriverDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (dto, _) => dto.toJson(),
        );
  }

  CollectionReference<TeamBasicInfoDto> teamsBasicInfo() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.teamsBasicInfo)
        .withConverter<TeamBasicInfoDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'TeamBasicInfo document is null';
            return TeamBasicInfoDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (dto, _) => dto.toJson(),
        );
  }

  DocumentReference<PlayerStatsDto> playerStats({
    required String playerId,
    required int season,
  }) =>
      FirebaseFirestore.instance
          .collection(_firebaseCollections.users.main)
          .doc(playerId)
          .collection(_firebaseCollections.users.stats)
          .doc(season.toString())
          .withConverter<PlayerStatsDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) throw 'PlayerStats document is null';
              return PlayerStatsDto.fromFirebase(
                playerId: playerId,
                season: int.parse(snapshot.id),
                json: data,
              );
            },
            toFirestore: (dto, _) => dto.toJson(),
          );
}
