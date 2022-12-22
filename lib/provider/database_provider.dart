import 'dart:collection';

import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static DatabaseProvider? _databaseProvider;
  static Database? _database;

  DatabaseProvider._createInstance();

  factory DatabaseProvider() {
    _databaseProvider ??= DatabaseProvider._createInstance();
    return _databaseProvider!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = '${databasesPath}friend_ai.db';

    var demoDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return demoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    //create table for character model
    var sql = generateSql("character", {
      "external_id": String,
      "title": String,
      "greeting": String,
      "avatar_file_name": String,
      "copyable": bool,
      "participant__name": String,
      "user__username": String,
      "participant__num_interactions": int,
      "img_gen_enabled": bool,
      "category": String,
      "last_history_id": String
    });
    print(sql);
    await db.execute(sql);
  }

  String generateSql(String tableName, Map<String, dynamic> columns) {
    String sql =
        'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT';
    //loop attribute columns
    for (String key in columns.keys) {
      var value = columns[key];
      if (value == String) {
        sql += ', $key TEXT';
      } else if (value == int) {
        sql += ', $key INTEGER';
      } else if (value == bool) {
        sql += ', $key INTEGER';
      }
    }

    sql += ')';
    return sql;
  }

  //select table to json
  Future<List<Map<String, dynamic>>> select(String tableName) async {
    Database db = await DatabaseProvider().database;
    var result = await db.rawQuery("SELECT * FROM $tableName");
    return result;
  }

  //insert json to table
  Future<int> insert(String tableName, Map<String, dynamic> json) async {
    Map<String, dynamic> data = {};
    //change bool to int
    for (String key in json.keys) {
      var value = json[key];
      if (value is bool) {
        data[key] = value ? 1 : 0;
      } else {
        data[key] = value;
      }
    }
    Database db = await DatabaseProvider().database;
    var result = await db.insert(tableName, data);
    return result;
  }

  //select one data
  Future<Map<String, dynamic>?> getCharacterByExternalId(
      String externalId) async {
    Database db = await DatabaseProvider().database;
    List<Map<String, dynamic>?> result =
        await db.query("character WHERE external_id = '$externalId'");
    if (result.length > 0) {
      return result.first;
    }
    return null;
  }
}
