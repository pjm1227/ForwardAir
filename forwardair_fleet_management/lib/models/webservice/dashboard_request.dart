//import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/endpoints.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:forwardair_fleet_management/models/error_model.dart';

class DashboardRequest {

  //To Load Dashboard Detail from the server
  Future<List<Dashboard_DB_Model>> loadDashboardDataFromServer(String authrizationToken) async {

    final url = '${EndPoints.DASHBOARD_URL}';

    var response = await http.post(url, headers: {
      'Accept': Constants.TEXT_CONTENT_TYPE,
      'Authorization': authrizationToken
    }).timeout(Duration(seconds: 30));
    if (response.statusCode == 200) {
      var jsonResponse = Dashboard_DB_Model().dashboardDBModelFromJson(response.body);
      return jsonResponse;
    } else {
      throw Exception(Constants.SOMETHING_WRONG);
    }
  }
}
