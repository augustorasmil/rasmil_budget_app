import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'rasmil_budget_app_aqflite');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE `category` ( `categoryID` INTEGER PRIMARY KEY AUTOINCREMENT, `categoryName` varchar(255), `categoryLimit` INTEGER, `categoryTotal` INTEGER, `categoryDate` DATETIME );");
    await database.execute(
        "CREATE TABLE `item` ( `itemID` INTEGER PRIMARY KEY AUTOINCREMENT, `itemName` varchar(255), `itemAmount` INTEGER, `itemDate` DATETIME, `categoryid` INTEGER, FOREIGN KEY (categoryID) REFERENCES category (categoryID) );");
  }
}
