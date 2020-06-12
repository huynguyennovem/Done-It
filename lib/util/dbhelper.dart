
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBHelper {

  static final _databaseName = "TodoAppDB.db";

  // Make this a singleton class.
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    DatabaseFactory dbFactory = databaseFactoryIo;
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await dbFactory.openDatabase(path);
  }


}