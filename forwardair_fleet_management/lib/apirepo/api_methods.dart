import 'dart:async';
import 'dart:convert';
import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:forwardair_fleet_management/utility/endpoints.dart';
import 'package:http/http.dart' as http;

///This class has API calling methods
///
class ApiMethods {
  ///This method handles request in GET
  Future<String> requestInGet(String url) async {
    final response = await http.get(url, headers: {
      "Content-Type": "application/json"
    }).timeout(Duration(seconds: 10));
    print(response.body);
    if (response.statusCode == 200) {
      /// If server returns an OK response, return the response
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //This method is used to make API call in POST
  Future<String> requestInPost(String url, String tokens, String body) async {
    print(url);
    //var json = '{"userName":"leasuretrucking@aol.com","password":"TESTING"}';
    var request = "'$body'";
    print(request.toString());
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": tokens != null ? tokens : null
    };
    final response = await http.post(url, body: body, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200)
      return response.body;
    else if (response.statusCode == 400) {
      return response.body;
    } else if (response.statusCode == 401) {
      return '{Unauthorized Error}';
    } else if (response.statusCode == 500) {
      return '{Server not responding}';
    } else {
      return '{Something went wrong}';
    }
  }

  //This method is used to make API call in POST
  Future<http.Response> postRequest(
      String url, String tokens, String body) async {
    print(url);
    var request = "'$body'";
    print(request.toString());
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": tokens != null ? tokens : null
    };
    final response = await http.post(url, body: body, headers: headers);
    return response;
  }
}
