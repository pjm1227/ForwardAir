import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:forwardair_fleet_management/blocs/events/dashboardevent.dart';
import 'package:forwardair_fleet_management/blocs/states/dashboardstate.dart';
import 'package:forwardair_fleet_management/models/webservice/dashboardresponsemodel.dart';
import 'package:forwardair_fleet_management/models/webservice/apimanager.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardState> {

  DashboardBloc();
  final apiManager = APIManager();

  @override
  get initialState => InitialState();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvents event) async* {
    if (event is FetchDashboardEvent) {
      try {
        if (currentState is InitialState ) {
          final posts = await _fetchDashboardDetails();
          yield DashboardLoaded(dashboardData: posts);
          return;
        }
//        if (currentState is DashboardLoaded) {
//          final posts = await _fetchDashboardDetails();
//          yield DashboardLoaded(
//            dashboardData: (currentState as DashboardLoaded).dashboardData + posts,
//          );
//        }
      } catch (_) {
        yield DashboardError();
      }
    }
  }

  Future<List<DashboardResponseModel>> _fetchDashboardDetails() async {
    var posts = await apiManager.loadDashboardDataFromServer();
    return posts;
  }

}