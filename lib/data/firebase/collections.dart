import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'model/driver_dto.dart';
import 'model/grand_prix_bet_dto.dart';
import 'model/grand_prix_bet_points_dto.dart';
import 'model/grand_prix_dto.dart';
import 'model/grand_prix_results_dto.dart';
import 'model/user_dto.dart';

@injectable
class FirebaseCollections {
  const FirebaseCollections();

  CollectionReference<GrandPrixDto> grandPrixes() => FirebaseFirestore.instance
      .collection('GrandPrixes')
      .withConverter<GrandPrixDto>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) throw 'Grand prix document data was null';
          return GrandPrixDto.fromFirebase(
            id: snapshot.id,
            json: data,
          );
        },
        toFirestore: (GrandPrixDto dto, _) => dto.toJson(),
      );

  CollectionReference<DriverDto> drivers() =>
      FirebaseFirestore.instance.collection('Drivers').withConverter<DriverDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) throw 'Driver document data was null';
              return DriverDto.fromFirebase(
                id: snapshot.id,
                json: data,
              );
            },
            toFirestore: (DriverDto dto, _) => dto.toJson(),
          );

  CollectionReference<GrandPrixResultsDto> grandPrixesResults() =>
      FirebaseFirestore.instance
          .collection('GrandPrixResults')
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

  CollectionReference<UserDto> users() =>
      FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
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
          .collection('Users')
          .doc(userId)
          .collection('GrandPrixBets')
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
          .collection('Users')
          .doc(userId)
          .collection('GrandPrixBetPoints')
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
}
