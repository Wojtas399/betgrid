import 'package:betgrid/model/user.dart';

User createUser({
  String id = 'u1',
  String email = 'user@example.com',
}) =>
    User(
      id: id,
      email: email,
    );
