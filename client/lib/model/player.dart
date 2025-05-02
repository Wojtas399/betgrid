import 'entity.dart';

class Player extends Entity {
  final String username;
  final String? avatarUrl;

  const Player({required super.id, required this.username, this.avatarUrl});

  @override
  List<Object?> get props => [id, username, avatarUrl];
}
