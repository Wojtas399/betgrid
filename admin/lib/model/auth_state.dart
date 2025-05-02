import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStateUserIsSignedIn extends AuthState {
  const AuthStateUserIsSignedIn();
}

class AuthStateUserIsSignedOut extends AuthState {
  const AuthStateUserIsSignedOut();
}
