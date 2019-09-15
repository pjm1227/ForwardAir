import 'package:forwardair_fleet_management/utility/endpoints.dart';

import 'api_methods.dart';

//This class is responsible to send required parameters to make API call and
// return back result to bloc
class Repository {
  final apiProvider = ApiMethods();

  /*
  This method is called when user request for login
   */
  Future<dynamic> makeLoginRequest(String body) =>
      apiProvider.requestInPost(EndPoints.LOGIN_URL, null, body);
}
