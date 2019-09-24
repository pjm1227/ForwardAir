//This class is used for all endpoint of url

class EndPoints {

  static const String BASE_URL =
      'https://test-api.forwardair.com/driverapprest/rest/';
  static const String DASHBOARD_URL = '$BASE_URL' + 'secure/dashboards/5';
  static const String LOGIN_URL = '$BASE_URL' + "user/login";
  static const String TERMS_TABLE = 'terms_accepted_table';
  static const String DRILL_DATA_URL = '$BASE_URL' +"secure/dashboard/drilldown";
  static const String LOAD_DETAIL_URL = '$BASE_URL' +"secure/loads";
}
