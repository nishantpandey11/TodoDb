import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tododb/model/todo.dart';

class DbHelper {
  //private instance of class : private is denoted by a "_"
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblTodo = "todo";
  String colId = "id";
  String colTitle = "title";
  String colPriority = "priority";
  String colDate = "date";
  String colDescription = "description";

  //private named ctor
  DbHelper._internal();

  //get single instance dbHelper (singleton) : same as getInstance
  factory DbHelper() => _dbHelper;

  static Database _db;

  //get single copy of db
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  //seq programming : dir will wait till getApplicationDocumentsDirectory
  //2. dbTodos will wait till openDatabase executes and so on..
  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int version) async {
    await db.execute("CREATE TABLE $tblTodo"
        "($colId INTEGER PRIMARY KEY,"
        "$colTitle TEXT,"
        "$colDescription TEXT,"
        "$colPriority INTEGER,"
        "$colDate TEXT)");
  }

  //result will be 0 if something went wrong otherwise it will contain the id or record inserted
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = db.insert(tblTodo, todo.toMap());
    print(result);
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result =
        db.rawQuery("SELECT * FROM $tblTodo order by $colPriority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count(*) from $tblTodo"));
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = db.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.getId()]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database db = await this.db;
    //var result = db.delete(tblTodo, where: "$colId = ?", whereArgs: [id]);
    var result = db.rawDelete("delete from $tblTodo where $colId = $id");
    return result;
  }
}
