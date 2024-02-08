import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInStateInitial extends SignInState {
  const SignInStateInitial();
}

class SignInStateComplete extends SignInState {
  const SignInStateComplete();
}

class SignInStateUserIsSignedIn extends SignInState {
  const SignInStateUserIsSignedIn();
}
