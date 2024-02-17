import 'entity.dart';

class User extends Entity {
  final String nick;
  final String? avatarUrl;

  const User({required super.id, required this.nick, this.avatarUrl});

  @override
  List<Object?> get props => [id, nick, avatarUrl];
}
