import 'package:rasmil_budget_app/repositories/database.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  readDataById(table, categoryId) async {
    var connection = await database;
    return await connection
        .query(table, where: 'categoryID=?', whereArgs: [categoryId]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection.update(table, data,
        where: "categoryID=?", whereArgs: [data['categoryID']]);
  }

  deleteData(table, categoryId) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM $table WHERE categoryID = $categoryId");
  }

  insertItem(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readItem(table, categoryId) async {
    var connection = await database;
    return await connection
        .query(table, where: 'categoryID=?', whereArgs: [categoryId]);
  }

  readAllItem(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  readItemById(table, itemId) async {
    var connection = await database;
    return await connection
        .query(table, where: 'itemID=?', whereArgs: [itemId]);
  }

  updateItem(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: "itemID=?", whereArgs: [data['itemID']]);
  }

  deleteItem(table, itemId) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM $table WHERE itemID = $itemId");
  }
}
