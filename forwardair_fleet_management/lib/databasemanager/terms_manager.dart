import 'package:forwardair_fleet_management/models/database/terms_model.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_helper.dart';

class TermsManager {
  var tableName = 'terms_accepted_table';

  //This method is used to get data from table
  Future<TermsModel> getData() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery('SELECT * FROM $tableName');
    List<TermsModel> list = result.isNotEmpty
        ? result.map((c) => TermsModel.fromMapObject(c)).toList()
        : [];
    return list != null && list.isNotEmpty ? list[0] : null;
  }

  //Insert into table
  Future<int> insertTermsData(Map<String, dynamic> row) async {
    TermsModel model = await getData();
    Database db = await DatabaseHelper.instance.database;
    return await db.insert(tableName, row);
    ;
  }
  //To Delete all items in db
  Future<int> deleteAll() async {
    Database db = await DatabaseHelper.instance.database;
    var result = db.rawDelete("Delete from $tableName");
    return result;
  }
}
