import 'barrels/chart.dart';
import 'package:bloc/bloc.dart';

class ChartBloc extends Bloc<ChartEvents, ChartStates> {
  @override
  ChartStates get initialState => InitialState();

  @override
  Stream<ChartStates> mapEventToState(
    ChartEvents event,
  ) async* {
    if (event is SelectEvent) {
      yield InitialState();
      yield SelectState(total: event.total);
    }
  }
}
