import 'dart:io';

import 'package:flutter_app/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  final String userTable = "userTable";
  final String columnId = "id";
  final String columnUserName = "username";
  final String columnPassword = "password";

//  here we are creating a single instance of the databasehelper class
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

//  now we are creating a factory so that every time we call the class its going to return the instance we created above
//  this is to ensure that we only create one single object of this class, because for the app we only need to instanciate this once

  factory DatabaseHelper() => _instance;

//  create an object of type database
  static Database _db;

  Future<Database> get db async {
//    if we already have a database
    if (_db != null) {
      return _db;
    }
//if we dont have the database we will create it
    _db = await initDb();
    return _db;
  }

// here we create a constructor called internal, internal is just a name it could have been any other name
// the idea here is that this constructor is going to be private to the current class
  DatabaseHelper.internal();

//  method to initialize the database
  initDb() async {
//    to create the database we will nedd to know where is it located on the device
    Directory documentDirectory = await getApplicationDocumentsDirectory();
//    this will provide the database path
    String path = join(documentDirectory.path, "maindb.db");

//    the line bellow will create the database
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreateMtd);
    return ourDb;
  }

  FutureOr<void> _onCreateMtd(Database db, int version) async {
//  here is where we are going to create our tables
//the db.execute will take a sql query and a list of arguments
    await db.execute(
        "CREATE TABLE $userTable($columnId INTEGER PRIMARY KEY, $columnUserName TEXT, $columnPassword TEXT)");
  }

//  this will Insert data into the database
  Future<int> saveUser(User user) async {
    var dbClient = await db;
//    now lets insert the values
    int res = await dbClient.insert(userTable, user.toMap());
    return res;
  }

//  get all the users in the database
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $userTable");
    return result.toList();
  }

//  to count the elements
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $userTable"));
  }

//  get a single user
  Future<User> getUser(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $userTable WHERE $columnId = $id");
    if (result.length == 0) return null;
//    result.first is going to return the first thing that it gets
    return new User.fromMap(result.first);
  }

//  delete user
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete(userTable,
        where: "$columnId = ?", whereArgs: [id]);
  }

//update
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(
      userTable, user.toMap(), where: "$columnId = ?", whereArgs: [user.id]);
  }

  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }
}
