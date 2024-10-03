import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'model/driver_dto/driver_dto.dart';
import 'model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
import 'model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'model/grand_prix_dto/grand_prix_dto.dart';
import 'model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'model/user_dto/user_dto.dart';

@injectable
class FirebaseCollections {
  const FirebaseCollections();

  String get name => 'name';

  //TODO: Add season param
  CollectionReference<GrandPrixDto> grandPrixes() => FirebaseFirestore.instance
      .collection('GrandPrixes')
      .withConverter<GrandPrixDto>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) throw 'Grand prix document data was null';
          return GrandPrixDto.fromFirebase(
            id: snapshot.id,
            season: 2024, //TODO: Pass season param here
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
              return DriverDto.fromIdAndJson(snapshot.id, data);
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
              return GrandPrixResultsDto.fromIdAndJson(snapshot.id, data);
            },
            toFirestore: (GrandPrixResultsDto dto, _) => dto.toJson(),
          );

  CollectionReference<UserDto> users() =>
      FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) throw 'User document data was null';
              return UserDto.fromIdAndJson(snapshot.id, data);
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
              return GrandPrixBetDto.fromIdPlayerIdAndJson(
                snapshot.id,
                userId,
                data,
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
              return GrandPrixBetPointsDto.fromIdPlayerIdAndJson(
                id: snapshot.id,
                playerId: userId,
                json: data,
              );
            },
            toFirestore: (GrandPrixBetPointsDto dto, _) => dto.toJson(),
          );
}

//TODO: Add season param
CollectionReference<GrandPrixDto> getGrandPrixesRef() =>
    FirebaseFirestore.instance
        .collection('GrandPrixes')
        .withConverter<GrandPrixDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Grand prix document data was null';
            return GrandPrixDto.fromFirebase(
              id: snapshot.id,
              season: 2024, //TODO: Pass season param here
              json: data,
            );
          },
          toFirestore: (GrandPrixDto dto, _) => dto.toJson(),
        );

CollectionReference<DriverDto> getDriversRef() =>
    FirebaseFirestore.instance.collection('Drivers').withConverter<DriverDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Driver document data was null';
            return DriverDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (DriverDto dto, _) => dto.toJson(),
        );

CollectionReference<GrandPrixResultsDto> getGrandPrixResultsRef() =>
    FirebaseFirestore.instance
        .collection('GrandPrixResults')
        .withConverter<GrandPrixResultsDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Grand prix result document data was null';
            return GrandPrixResultsDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (GrandPrixResultsDto dto, _) => dto.toJson(),
        );

CollectionReference<UserDto> getUsersRef() =>
    FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'User document data was null';
            return UserDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (UserDto dto, _) => dto.toJson(),
        );

CollectionReference<GrandPrixBetDto> getGrandPrixBetsRef(String userId) =>
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('GrandPrixBets')
        .withConverter<GrandPrixBetDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Grand prix bet document was null';
            return GrandPrixBetDto.fromIdPlayerIdAndJson(
              snapshot.id,
              userId,
              data,
            );
          },
          toFirestore: (GrandPrixBetDto dto, _) => dto.toJson(),
        );

CollectionReference<GrandPrixBetPointsDto> getGrandPrixBetPointsRef(
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
            return GrandPrixBetPointsDto.fromIdPlayerIdAndJson(
              id: snapshot.id,
              playerId: userId,
              json: data,
            );
          },
          toFirestore: (GrandPrixBetPointsDto dto, _) => dto.toJson(),
        );
