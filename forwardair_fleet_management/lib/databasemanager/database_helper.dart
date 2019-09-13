import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "fleet_owner.db";
  static final _databaseVersion = 1;

  static final termsAcceptedTable = 'terms_accepted_table';

  final columnId = 'id';
  final columnIsAccepted = 'columnIsAccepted';

  //Columns for User Table
  final id = 'id';
  final token = 'token';
  final emailAddress = 'emailAddress';
  final fullName = 'fullName';
  final userId = 'userId';
  final stationCd = 'stationCd';
  final participantId = 'participantId';
  final phone = 'phone';
  final companyCd = 'companyCd';
  final contractorcd = 'contractorcd';
  final driverid = 'driverid';
  final driveroid = 'driveroid';
  final faauthuseroid = 'faauthuseroid';
  final xrefoid = 'xrefoid';
  final faauthuserid = 'faauthuserid';
  final usertype = 'usertype';
  final activetractors = 'activetractors';
  final isUserLoggedIn = 'isUserLoggedIn';

  //Columns for Dashboard Table
  String tableName = 'DashboardTable';
  String colId = 'id';
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

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _dbObj;

  Future<Database> get database async {
    if (_dbObj != null) return _dbObj;
    // lazily instantiate the db the first time it is accessed
    _dbObj = await _initDatabase();
    return _dbObj;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $termsAcceptedTable ($columnId INTEGER PRIMARY KEY, $columnIsAccepted INTEGER NOT NULL)');
    await db.execute(
        'CREATE TABLE user_table ($id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $token TEXT, $emailAddress TEXT, $fullName TEXT,'
        ' $userId TEXT, $stationCd TEXT, $participantId TEXT, $phone TEXT, $companyCd TEXT,'
        ' $contractorcd TEXT, $driverid TEXT, $driveroid TEXT, $faauthuseroid TEXT, $xrefoid TEXT, '
        ' $faauthuserid TEXT, $usertype TEXT, $activetractors TEXT,'
        ' $isUserLoggedIn INTEGER NOT NULL)');
    await db.execute("""CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $companyCd TEXT, 
                    $contractorCd TEXT, $weekStart TEXT,$weekEnd TEXT, $month INTEGER, $year TEXT, 
                    $tractorCount INTEGER, $totalMiles INTEGER, $loadedMiles INTEGER, $emptyMiles INTEGER, 
                    $totalLoads INTEGER, $loadedLoads INTEGER, $emptyLoads INTEGER, $totalTractorGallons DOUBLE,
                    $totalFuelCost DOUBLE, $grossAmt DOUBLE, $deductions DOUBLE, $netAmt DOUBLE, $dashboardPeriod TEXT )""");
  }
}
