import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 2;
  static const String _tableName = 'tasks1';

  Future<bool> initDB() async {
    /*if (_db != null) {
      print('DB Is Not Null');
      return;
    }*/
    /*
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath demo.db';
    print('Good');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    });*/

    try {
      //String path = '${await getDatabasesPath()}task15.db';
      var databasesPath = await getDatabasesPath();
      String path = '$databasesPath task21.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print('>>>>>>>>>>>>>>>>>>> Create DB');
          await db.execute(
              ' CREATE TABLE $_tableName ( id INTEGER PRIMARY KEY autoincrement , title TEXT , note TEXT , dates TEXT , startTime TEXT , endTime TEXT ,  remind INTEGER , repeat TEXT ,  color INTEGER  , isCompleted INTEGER ) ');
        },
      );
      print(_db?.isOpen);
      return true;
    } catch (e) {
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ $e');
      return false;
    }
/*
    await _db?.transaction((txn) async {
      /*  int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');*/
      int id2 = await txn.rawInsert(
          'INSERT INTO $_tableName (title, note, dates,startTime,endTime,remind,repeat,color,isCompleted) VALUES(?, ?, ?,?,?,?,?,?,?)',
          ['aaa', 'aaa', 'aaa', 'aaa', 'aaa', '1', 'aaa', '1', '1']);
      print('inserted2: $id2');
    });*/
  }

  Future<int?> insertTask(Task task) async {
    print('Insert task...');
    print(task.toJson());
    int id2 = -1;
    await _db?.transaction((txn) async {
      id2 = await txn.rawInsert(
          'INSERT INTO $_tableName (title, note, dates,startTime,endTime,remind,repeat,color,isCompleted) VALUES(?, ?, ?,?,?,?,?,?,?)',
          [
            task.title,
            task.note,
            task.dates,
            task.startTime,
            task.endTime,
            task.remind,
            task.repeat,
            task.color,
            task.isCompleted
          ]);
      print('inserted2>>>: $id2');
    });
    return id2;
    //return id2;
    //return _db.insert(_tableName, task.toJson());
  }

  Future<int>? deleteTask(Task task) {
    print('Delete task...');
    return _db?.delete(_tableName, where: ' id = ?', whereArgs: [task.id]);
  }

  Future<int>? deleteAllTask() {
    print('Delete All task...');
    return _db?.delete(_tableName);
  }

  Future<int>? updateTask(Task task) {
    print('Update task...');
    return _db?.update(_tableName, task.toJson(),
        where: ' id = ?', whereArgs: [task.id]);
  }

  Future<int>? updateRowTask(Task task) {
    print(task.id);

    //print('Update Row task...');
    return _db?.rawUpdate(
        'update $_tableName set isCompleted = ? where id = ?', [1, task.id]);
  }

  Future<List<Map<String, dynamic>>>? selectAllTask() {
    print('Select task...');
    return _db?.query(_tableName);
  }
}
