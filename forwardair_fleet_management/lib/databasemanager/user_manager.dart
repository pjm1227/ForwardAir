import 'package:forwardair_fleet_management/models/login_model.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_helper.dart';

class UserManager {
  var tableName = 'user_table';

  //This method is used to get data from table
  Future<UserDetails> getData() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery('SELECT * FROM $tableName');
    try {
      List<UserDetails> list = result.isNotEmpty
          ? result.map((c) => UserDetails.fromMapObject(c)).toList()
          : [];
      return list != null && list.isNotEmpty ? list[0] : null;
    } catch (_) {
      return null;
    }
  }

  //Insert into table
  Future<int> insertTermsData(Map<String, dynamic> row) async {
    UserDetails model = await getData();
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, row);
  }

  //To Delete all items in db
  Future<int> deleteAll() async {
    Database db = await DatabaseHelper.instance.database;
    var result = db.rawDelete("Delete from $tableName");
    return result;
  }
}
