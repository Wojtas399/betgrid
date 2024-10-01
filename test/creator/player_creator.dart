import 'package:betgrid/model/player.dart';

class PlayerCreator {
  final String id;
  final String username;
  final String? avatarUrl;

  const PlayerCreator({
    this.id = '',
    this.username = '',
    this.avatarUrl,
  });

  Player createEntity() => Player(
        id: id,
        username: username,
        avatarUrl: avatarUrl,
      );
}
