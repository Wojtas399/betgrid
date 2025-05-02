import 'entity.dart';

abstract class SeasonEntity extends Entity {
  final int season;

  const SeasonEntity({required super.id, required this.season});
}
