import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../service/date_service.dart';

@injectable
class SeasonCubit extends Cubit<int> {
  SeasonCubit(DateService dateService) : super(dateService.getNow().year);
}
