import 'package:forwardair_fleet_management/utility/endpoints.dart';

import 'api_methods.dart';

//This class is responsible to send required parameters to make API call and
// return back result to bloc
class Repository {
  ApiMethods _apiProvider = ApiMethods();

  /*
  This method is called when user request for login
   */
  Future<dynamic> makeLoginRequest(String body) =>
      _apiProvider.requestInPost(EndPoints.LOGIN_URL, null, body);

  /*
  This method is called when user request for dashboard
   */
  Future<dynamic> makeDashboardRequest(String token) =>
      _apiProvider.requestInPost(EndPoints.DASHBOARD_URL, token, null);

  /*
   * This method called DrillDown API
   */
  Future<dynamic> makeDrillDataRequest(String body, String token) =>
      _apiProvider.requestInPost(EndPoints.DRILL_DATA_URL, token, body);

  /*
   * This method called Chart API
   */
  Future<dynamic> makeChartDataRequest(String body, String token) =>
      _apiProvider.requestInPost(EndPoints.CHART_DATA_URL, token, body);

  /*
  This method is called when user request for load/mile details for a tractor
   */

  Future<dynamic> makeTractorLoadsDetailRequest(String body, String token) =>
      _apiProvider.requestInPost(EndPoints.LOAD_DETAIL_URL, token, body);

  /*
  This method is called when user request for settlement
   */

  Future<dynamic> makeSettlementRequest(String body, String token) =>
      _apiProvider.requestInPost(EndPoints.SETTLEMENT_URL, token, body);

  /*
  This method is called when user request for tractor fuel details
   */

  Future<dynamic> makeTractorFuelDetailsRequest(String body, String token) =>
      _apiProvider.requestInPost(EndPoints.TRACTOR_FUEL_DETAILS, token, body);

  /*
  This method is called when user request for tractor settlement
   */

  Future<dynamic> makeSettlementDetailRequest(String body, String token) =>
      _apiProvider.requestInPost(EndPoints.TRACTOR_SETTLEMENT, token, body);
}
