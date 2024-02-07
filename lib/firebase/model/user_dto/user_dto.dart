import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserDto extends Equatable {
  final String id;
  final String email;

  const UserDto({required this.id, required this.email});

  @override
  List<Object?> get props => [id, email];

  UserDto.fromFirebaseUser(firebase_auth.User firebaseUser)
      : this(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
        );
}
