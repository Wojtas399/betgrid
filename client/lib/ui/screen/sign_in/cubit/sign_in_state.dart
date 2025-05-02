abstract class SignInState {
  const SignInState();
}

class SignInStateLoading extends SignInState {
  const SignInStateLoading();
}

class SignInStateCompleted extends SignInState {
  const SignInStateCompleted();
}

class SignInStateUserIsAlreadySignedIn extends SignInState {
  const SignInStateUserIsAlreadySignedIn();
}
