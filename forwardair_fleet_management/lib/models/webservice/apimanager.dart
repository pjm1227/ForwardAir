//import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:forwardair_fleet_management/models/webservice/dashboardresponsemodel.dart';
import 'package:forwardair_fleet_management/utility/Constants.dart';

class APIManager {
  String contentType = 'application/json';
  String authrizationToken =
      'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkcml2ZXJhcHByZXN0IiwidUZOYW1lIjoiRGFubnkgTGVhc3VyZSIsInVFSWQiOiJsZWFzdXJldHJ1Y2tpbmdAYW9sLmNvbSIsInVTdENkIjoiREZXIiwidUlkIjoibGVhc3VyZXRydWNraW5nQGFvbC5jb20iLCJ1T2lkIjoxMzM2LCJhcHBOYW1lIjoiZHJpdmVyYXBwcmVzdCIsInVYT2lkIjoxODA1LCJ1VHlwZSI6IkZPIiwidUNtcHlDZCI6IkxURkEiLCJ1Q250ckNkIjoiVFJVQy1MRUFTIiwidUdyb3VwcyI6W3siZ3JvdXBObSI6IkxUTF9FWFBFRElURURfQ09OVFJBQ1RPUiIsImRlc2NyaXB0aW9uIjoiQ09OVFJBQ1RPUiIsInVzZXJSb2xlcyI6W3sicm9sZU5tIjoiQVBQX1VTRVIiLCJkZXNjcmlwdGlvbiI6IkRSSVZFUl9NT0JJTEVfQVBQX1VTRVIifSx7InJvbGVObSI6IlNFVFRMRU1FTlRTX1ZJRVciLCJkZXNjcmlwdGlvbiI6IlNFVFRMRU1FTlRTX1ZJRVcifSx7InJvbGVObSI6IlNBRkVUWV9SRVBPUlRfVklFVyIsImRlc2NyaXB0aW9uIjoiU0FGRVRZX1JFUE9SVF9WSUVXIn0seyJyb2xlTm0iOiJCUkVBS0RPV05fUkVQT1JUX1ZJRVciLCJkZXNjcmlwdGlvbiI6IkJSRUFLRE9XTl9SRVBPUlRfVklFVyJ9LHsicm9sZU5tIjoiSE9NRVRJTUVfUkVRVUVTVF9WSUVXIiwiZGVzY3JpcHRpb24iOiJIT01FVElNRV9SRVFVRVNUX1ZJRVcifSx7InJvbGVObSI6IkRBU0hCT0FSRCIsImRlc2NyaXB0aW9uIjoiREFTSEJPQVJEIn0seyJyb2xlTm0iOiJDT01QQU5ZX05FV1MiLCJkZXNjcmlwdGlvbiI6IkNPTVBBTllfTkVXUyJ9XX1dLCJ0b2tUbXN0cCI6MTU3MDY4OTA1MDA1Mn0.WmuebGugc0PdxmwjwEokTCtA-LrW88f3XvVbHck63jg0CABtz8KpWe8-CikNlGEcLe2NWAMpggCM4yQsU_IyVA';

  //To Load Dashboard Detail from the server
  Future<List<DashboardResponseModel>> loadDashboardDataFromServer() async {
    final url = '${Constants.BASE_URL}/${Constants.DASHBOARD_URL}/5';
    var response = await http.post(url, headers: {
      'Accept': contentType,
      'Authorization': authrizationToken
    }).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      var jsonResponse = dashboardResponseModelFromJson(response.body); //convert.jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Failed to dashboard details");
    }
  }
}
