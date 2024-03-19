import 'package:equatable/equatable.dart';

sealed class LoggedUserControllerState extends Equatable {
  const LoggedUserControllerState();

  @override
  List<Object?> get props => [];
}

class LoggedUserControllerStateInitial extends LoggedUserControllerState {
  const LoggedUserControllerStateInitial();
}

class LoggedUserControllerStateLoggedUserIdNotFound
    extends LoggedUserControllerState {
  const LoggedUserControllerStateLoggedUserIdNotFound();
}

class LoggedUserControllerStateDataSaved extends LoggedUserControllerState {
  const LoggedUserControllerStateDataSaved();
}

class LoggedUserControllerStateUsernameUpdated
    extends LoggedUserControllerState {
  const LoggedUserControllerStateUsernameUpdated();
}

class LoggedUserControllerStateAvatarUpdated extends LoggedUserControllerState {
  const LoggedUserControllerStateAvatarUpdated();
}

class LoggedUserControllerStateNewUsernameIsAlreadyTaken
    extends LoggedUserControllerState {
  const LoggedUserControllerStateNewUsernameIsAlreadyTaken();
}

class LoggedUserControllerStateEmptyUsername extends LoggedUserControllerState {
  const LoggedUserControllerStateEmptyUsername();
}
