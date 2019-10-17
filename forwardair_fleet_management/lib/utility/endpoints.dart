//This class is used for all endpoint of url

class EndPoints {

  static const String BASE_URL =
      'https://api.forwardair.com/driverapprest/rest/';
  static const String DASHBOARD_URL = '$BASE_URL' + 'secure/dashboards/5';
  static const String LOGIN_URL = '$BASE_URL' + "user/login";
  static const String TERMS_TABLE = 'terms_accepted_table';
  static const String DRILL_DATA_URL = '$BASE_URL' +"secure/dashboard/drilldown";
  static const String CHART_DATA_URL = '$BASE_URL' +"secure/dashboard/breakdown";
  static const String LOAD_DETAIL_URL = '$BASE_URL' +"secure/loads";
  static const String SETTLEMENT_URL = '$BASE_URL' +"secure/settlements";
  static const String TRACTOR_FUEL_DETAILS = '$BASE_URL' +"secure/fuel-usage";
  static const String TRACTOR_SETTLEMENT = '$BASE_URL' +"secure/settlement-details";
  static const String FLEET_TRACKER_URL = '$BASE_URL' +"secure/fleet-tracker";
  static const String TRACTOR_REVENUE_DETAILS= '$BASE_URL' +"secure/settlement-transaction";
}
