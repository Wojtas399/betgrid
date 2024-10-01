import '../../model/driver.dart';
import '../firebase/model/driver_dto/driver_dto.dart';

Team mapTeamFromDto(TeamDto teamDto) => switch (teamDto) {
      TeamDto.mercedes => Team.mercedes,
      TeamDto.alpine => Team.alpine,
      TeamDto.haasF1Team => Team.haasF1Team,
      TeamDto.redBullRacing => Team.redBullRacing,
      TeamDto.mcLaren => Team.mcLaren,
      TeamDto.astonMartin => Team.astonMartin,
      TeamDto.rb => Team.rb,
      TeamDto.ferrari => Team.ferrari,
      TeamDto.kickSauber => Team.kickSauber,
      TeamDto.williams => Team.williams,
    };
