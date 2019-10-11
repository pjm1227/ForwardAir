import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_helper.dart';

class DashboardManager {
  var tableName = 'DashboardTable';

  //To get all Dashboard Objs from the DB
  Future<List<Map<String, dynamic>>> getAllObjectsFromDB() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.query(tableName);
    return result;
  }

  //To update data into DB
  Future<int> updateDashboardDB(Dashboard_DB_Model _dashboardModel) async{
    Database db = await DatabaseHelper.instance.database;
    var result = await db.update(tableName, _dashboardModel.toMap(), where: 'dashboardPeriod = ?', whereArgs: [_dashboardModel.dashboardPeriod]);
    return result;
  }

//To insert data into DB
  Future<int> insertIntoDashboardDB(Dashboard_DB_Model apiModel) async{
    Database db = await DatabaseHelper.instance.database;
//    db.transaction(((Transaction txn) async {
//      for() {
//
//        var result = await db.insert(tableName, apiModel.toMap());
//      }
//    }));
    var result = await db.insert(tableName, apiModel.toMap());
    return result;
  }

  //To Delete all items in db
  Future<int> deleteAll() async {
    Database db = await DatabaseHelper.instance.database;
    var result = db.rawDelete("Delete from $tableName");
    return result;
  }

  Future<bool> isDashboardPeriodeExist(Dashboard_DB_Model _model) async{
    Database db = await DatabaseHelper.instance.database;
    var queryResult = await db.rawQuery('SELECT * FROM $tableName WHERE dashboardPeriod = "${_model.dashboardPeriod}"');
   // var queryAll= await db.rawQuery('SELECT * FROM $tableName');
    //print(" size ${queryAll.length}");
   // print('SELECT * FROM $tableName WHERE dashboardPeriod = "${_model.dashboardPeriod}"');
    if (queryResult.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  //To fetch each model and convert map
  Future<Dashboard_DB_Model> fetchAnItemAndconvertMapToDashboard() async {
    //Fetch all data from DB for each model
    var mapList = await getAllObjectsFromDB();
    var dashboard = Dashboard_DB_Model();
    int count = mapList.length;
    for (int i = 0; i < count; i++) {
      dashboard = Dashboard_DB_Model.fromMapObject(mapList[i]);
    }
    return dashboard;
  }

  //To fetch all list and convert map to List
  Future<List<Dashboard_DB_Model>> fetchAllAndConvertMaplistToDashboardList() async {
    //Fetch all data from DB
    var mapList = await getAllObjectsFromDB();
    var dashboardList = List<Dashboard_DB_Model>();
    int count =  mapList.length;
    for (int i = 0; i < count; i++ ) {
      dashboardList.add(Dashboard_DB_Model.fromMapObject(mapList[i]));
    }
    return dashboardList;
  }

}
