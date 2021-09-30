// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:chase_your_goals/data/models/event.dart';
import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/data/models/tag.dart';
import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseRepository {
  DatabaseRepository();

  static DatabaseRepository instance = DatabaseRepository();

  static Database? _db;

  Future<Database> get db async => _db ?? await _initDB();

  Future<Database> _initDB() async {
    String dbPath = await databasePath;

    if (!(await databaseExists(dbPath))) {
      ByteData data = await rootBundle.load("assets/databases/cyg_database.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    _db = await openDatabase(dbPath, version: 1);
    return _db!;
  }

  Future<String> get databasePath async =>
      (await getDatabasesPath()) + "cyg_database.db";

  Future<List<Note>> getNotes({NoteStatus? status, Tag? tag}) async {
    List<Map> notes = await (await db).rawQuery("SELECT * FROM Notes");
    for (Map note in notes) {
      print(note);
    }
    return [];
  }

  //adding events or notes
  Future<void> addTask(Note object) async {
    print("attempting to add task");
    late int res;
    if (object.runtimeType == Event) {
      print("adding event");
      print(
          "INSERT INTO Events (title, description, date_added, repeat_mode, status, date_due) VALUES ('${object.title}', '${object.description}', '${DateTime.now()}', '${(object as Event).repeatMode == null ? 'NULL' : describeEnum((object).repeatMode!)}', '${describeEnum(NoteStatus.inProgress)}', '${object.dateDue}')");
      res = await (await db).rawInsert(
        "INSERT INTO Events (title, description, date_added, repeat_mode, status, date_due) VALUES (${object.title}, ${object.description}, ${DateTime.now()}, ${(object as Event).repeatMode == null ? 'NULL' : describeEnum((object).repeatMode!)}, ${describeEnum(NoteStatus.inProgress)}, ${object.dateDue})",
      );
    } else {
      res = await (await db).rawInsert(
        "INSERT INTO Notes (title, description, date_added, status) VALUES (${object.title}, ${object.description ?? 'NULL'}, ${DateTime.now()}, ${describeEnum(NoteStatus.inProgress)})",
      );
      print("adding note");
      print(
          "INSERT INTO Notes (title, description, date_added, status) VALUES ('${object.title}', '${object.description ?? 'NULL'}, ${DateTime.now()}', '${describeEnum(NoteStatus.inProgress)}')");
    }
    print(res);
    if (res == 0) throw Exception("Couldn't insert into db");
  }
}
