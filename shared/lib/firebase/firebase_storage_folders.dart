class FirebaseStorageFolders {
  const FirebaseStorageFolders();

  String teamLogoImgsPath(int season) => '${_seasonPath(season)}/TeamLogos';
  String carImgsPath(int season) => '${_seasonPath(season)}/Cars';

  String _seasonPath(int season) => 'Season/$season';
}
