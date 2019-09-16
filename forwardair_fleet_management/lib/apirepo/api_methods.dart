import 'dart:async';
import 'dart:convert';
import 'package:forwardair_fleet_management/models/error_model.dart';
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
  Future<dynamic> requestInPost(String url, String tokens, String body) async {
    print(url);
    //var json = '{"userName":"leasuretrucking@aol.com","password":"TESTING"}';
    var request = "'$body'";
    print('Request body is $request');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": tokens != null ? tokens : null
    };
    var responseJson;
    try {
      final response = await http
          .post(url, body: body == null ? null : body, headers: headers)
          .timeout(Duration(seconds: 20));
      responseJson = _returnResponse(response);
    } on TimeoutException catch (_) {
      var map = '{"errorMessage": "Timeout"}';
      responseJson = ErrorModel.fromJson(json.decode(map));
    }
    print('response model is $responseJson');
    return responseJson;
  }

  //Exception handling based on result codes
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return response.body;
      case 400:
        final errorModel = ErrorModel.fromJson(json.decode(response.body));
        return errorModel;
      case 401:
        final errorModel = ErrorModel.fromJson(json.decode(response.body));
        return errorModel;
      case 403:
        final errorModel = ErrorModel.fromJson(json.decode(response.body));
        return errorModel;
      case 500:
        final errorModel = ErrorModel.fromJson(json.decode(response.body));
        return errorModel;
      default:
        var map = '{"errorMessage": "Something went wrong"}';
        final errorModel = ErrorModel.fromJson(json.decode(map));
        return errorModel;
    }
  }
}
