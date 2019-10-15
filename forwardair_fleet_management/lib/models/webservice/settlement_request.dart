import 'package:http/http.dart' as http;

import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:forwardair_fleet_management/utility/endpoints.dart';
import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';

class SettlementRequest {
  final int month;
  final int year;

  SettlementRequest(this.month, this.year);

  Map<String, dynamic> toJson() => {
        '"month"': '"$month"',
        '"year"': '"$year"',
      };
}
