import 'package:betgrid/model/player.dart';

Player createPlayer({
  String id = '',
  String username = '',
  String? avatarUrl,
}) =>
    Player(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
    );
