import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateComplete extends AuthState {
  const AuthStateComplete();
}

class AuthStateUserIsSignedIn extends AuthState {
  const AuthStateUserIsSignedIn();
}
