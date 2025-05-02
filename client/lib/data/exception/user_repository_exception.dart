abstract class UserRepositoryException {
  const UserRepositoryException();
}

class UserRepositoryExceptionUsernameAlreadyTaken
    extends UserRepositoryException {
  const UserRepositoryExceptionUsernameAlreadyTaken();
}

class UserRepositoryExceptionUserNotFound extends UserRepositoryException {
  const UserRepositoryExceptionUserNotFound();
}
