import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';

import 'package:forwardair_fleet_management/models/database/dashboard_db_model.dart';

class Dashboard_DBProvider {
  static Dashboard_DBProvider _datebaseHelper;
  static Database _database;

  String tableName = 'DashboardTable';
  String colId = 'id';
  String companyCd = 'companyCd';
  String contractorCd = 'contractorCd';
  String weekStart = 'weekStart';
  String weekEnd = 'weekEnd';
  String month = 'month';
  String year = "year";
  String tractorCount = 'tractorCount';
  String totalMiles = 'totalMiles';
  String loadedMiles = 'loadedMiles';
  String emptyMiles = 'emptyMiles';
  String totalLoads = 'totalLoads';
  String loadedLoads = 'loadedLoads';
  String emptyLoads = 'emptyLoads';
  String totalTractorGallons = 'totalTractorGallons';
  String totalFuelCost = 'totalFuelCost';
  String grossAmt = 'grossAmt';
  String deductions = 'deductions';
  String netAmt = 'netAmt';
  String dashboardPeriod = 'dashboardPeriod';

  Dashboard_DBProvider._createInstance();

  factory Dashboard_DBProvider() {
    if (_datebaseHelper == null) {
      _datebaseHelper = Dashboard_DBProvider._createInstance();
    }
    return _datebaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get path of the directory for android and iOS.
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'DashboardDB.db');
    //open/create database at a given path
    var createdDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return createdDB;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute("""CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $companyCd TEXT, 
                    $contractorCd TEXT, $weekStart TEXT,$weekEnd TEXT, $month INTEGER, $year TEXT, 
                    $tractorCount INTEGER, $totalMiles INTEGER, $loadedMiles INTEGER, $emptyMiles INTEGER, 
                    $totalLoads INTEGER, $loadedLoads INTEGER, $emptyLoads INTEGER, $totalTractorGallons DOUBLE,
                    $totalFuelCost DOUBLE, $grossAmt DOUBLE, $deductions DOUBLE, $netAmt DOUBLE, $dashboardPeriod TEXT )""");
  }

  //To get all Dashboard Objs from the DB
  Future<List<Map<String, dynamic>>> getAllObjectsFromDB() async {
    Database db = await database;
    var result = await db.query(tableName, orderBy: '$colId ASC');
    return result;
  }

//To insert data into DB
  Future<int> insertIntoDashboardDB(Dashboard_DB_Model apiModel) async{
    Database db = await this.database;
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
    final db = await database;
    var result = db.rawDelete("Delete from DashboardTable");
    return result;
  }

//To fetch and convert map to List
  Future<List<Dashboard_DB_Model>> convertMaplistToDashboardList() async {
    //Fetch all data from DB
    var mapList = await getAllObjectsFromDB();
    var dashboardList = List<Dashboard_DB_Model>();
    int count =  mapList.length;
    for (int i = 0; i < count;   i++ ) {
      dashboardList.add(Dashboard_DB_Model.fromMapObject(mapList[i]));
    }
    return dashboardList;
  }

}