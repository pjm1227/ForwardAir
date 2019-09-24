import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_helper.dart';

class UserRoleManager {
  var tableName = 'user_role';

  //This method is used to get data from table
  Future<List<UserRole>> getUserRoles() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery('SELECT * FROM $tableName');
    try {
      List<UserRole> list = result.isNotEmpty
          ? result.map((c) => UserRole.fromMapObject(c)).toList()
          : [];
      return list != null && list.isNotEmpty ? list : null;
    } catch (_) {
      return null;
    }
  }

  //Insert into table
  Future<int> insertUserRole(Map<String, dynamic> row) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, row);
  }

  //To Delete all items in db
  Future<int> deleteUserRoles() async {
    Database db = await DatabaseHelper.instance.database;
    var result = db.rawDelete("Delete from $tableName");
    return result;
  }
}
