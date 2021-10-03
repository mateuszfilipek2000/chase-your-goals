// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:typed_data';

import 'package:chase_your_goals/data/models/event.dart';
import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/data/models/tag.dart';
import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:chase_your_goals/data/extensions/date_helpers.dart';
import 'dart:math' as math;

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

  Future<List<Note>> getNotes({NoteStatus? status, String? startsWith}) async {
    //List<Map> notes = await (await db).rawQuery("SELECT * FROM Notes");
    List<Note> results = [];

    String query =
        "SELECT Notes.title as title, Notes.description as description, DATETIME(Notes.date_added) as date_added, Notes.date_finished as date_finished, group_concat(DISTINCT Tags.name) as tags, Tags.color as color "
        "FROM NotesWithTags "
        "INNER JOIN Notes ON NotesWithTags.noteID = Notes.id "
        "INNER JOIN Tags ON NotesWithTags.tagID = Tags.id ";
    if (startsWith != null) {
      query += "WHERE Notes.title "
          "LIKE '$startsWith%' ";
    }
    query += "GROUP BY Notes.id "
        "UNION "
        "SELECT title, description, DATETIME(date_added), date_finished, null AS tags, null as color "
        "FROM Notes "
        "WHERE id not in (SELECT noteID FROM NotesWithTags) ";
    if (startsWith != null) {
      query += "AND Notes.title "
          "LIKE '$startsWith%' ";
    }
    query += "ORDER BY DATETIME(Notes.date_added) DESC";

    List<Map> notes = await (await db).rawQuery(query);

    // print(notes);

    for (Map note in notes) {
      print(note);
      print(note["color"]);
      results.add(
        Note(
          note["title"],
          note["description"],
          DateTime.parse(note["date_added"]),
          note["date_finished"] == null ||
                  note["date_finished"] == "" ||
                  note["date_finished"] == "null"
              ? null
              : DateTime.parse(note["date_finished"]),
          color: note["color"] == null ||
                  note["color"] == "" ||
                  note["color"] == "null"
              ? null
              : note["color"],
          tags: note["tags"],
        ),
      );
    }
    return results;
  }

  Future<List<Event>> getEvents(
      {NoteStatus? status, Tag? tag, String? startsWith}) async {
    //List<Map> notes = await (await db).rawQuery("SELECT * FROM Notes");
    List<Event> results = [];

    String query =
        "SELECT Events.title as title, Events.description as description, DATETIME(Events.date_added) as date_added, Events.date_finished as date_finished, Events.date_due as date_due, Events.repeat_mode as repeat_mode, group_concat(DISTINCT Tags.name) as tags, Tags.color AS color "
        "FROM EventsWithTags "
        "INNER JOIN Events ON EventsWithTags.eventID = Events.id "
        "INNER JOIN Tags ON EventsWithTags.tagID = Tags.id ";
    if (startsWith != null) {
      query += "WHERE Events.title "
          "LIKE '$startsWith%' ";
    }
    query += "GROUP BY Events.id "
        "UNION "
        "SELECT title, description, DATETIME(date_added), date_finished, date_due, repeat_mode, null AS tags, null AS color  "
        "FROM Events "
        "WHERE id not in (SELECT eventID FROM EventsWithTags) ";
    if (startsWith != null) {
      query += "AND Events.title "
          "LIKE '$startsWith%' ";
    }
    query += "ORDER BY DATETIME(Events.date_added) DESC";

    List<Map> events = await (await db).rawQuery(query);

    //print(events);
    for (Map event in events) {
      print(event);
      results.add(
        Event(
          event["title"],
          event["description"],
          DateTime.parse(event["date_added"]),
          event["date_finished"] == null ||
                  event["date_finished"] == "" ||
                  event["date_finished"] == "NULL"
              ? null
              : DateTime.parse(event["date_finished"]),
          DateTime.parse(event["date_due"]),
          event["repeat_mode"] == null ||
                  event["repeat_mode"] == "" ||
                  event["repeat_mode"] == "NULL"
              ? null
              : event["repeat_mode"],
          color: event["color"] == null ||
                  event["color"] == "null" ||
                  event["color"] == ""
              ? null
              : event["color"],
          tags: event["tags"],
        ),
      );
    }
    return results;
  }

  ///adding events or notes
  ///pass tags separated by comma
  Future<void> addTask(Note object, {String tagsAll = ""}) async {
    print("attempting to add task");
    late int res;
    String query;
    List<String> tags = [];
    DateTime now = DateTime.now();
    //tags are sorted by importance (first added tag has importance of 1, second one has importance of 2 and so on)
    //when displaying events/notes with tags, note/event has the color of the tag with the lowest importance
    int importance = 1;

    if (tagsAll.replaceAll(" ", "") != "") {
      tags = tagsAll.split(',');

      //checking if any of tags are already in db
      for (String tag in tags) {
        tag = tag.replaceAll(" ", "");
        // print(tag);
        var tagChecker = await (await db)
            .rawQuery("SELECT COUNT(1) FROM Tags WHERE name='$tag'");
        // var tagChecker = await (await db).rawQuery("SELECT * FROM table_name");

        //if this value equals 0 then checked tag is unique and should be added to db
        if (tagChecker[0]['COUNT(1)'] == 0) {
          //adding tag to db

          //randomizing tag color
          // int randomColor = int.parse('0xFF${math.Random().nextInt(0xFFFFFF)}');
          int randomColor = Colors
              .primaries[math.Random().nextInt(Colors.primaries.length)].value;

          res = await (await db).rawInsert(
              "INSERT INTO Tags (name, color) VALUES ('$tag', '${randomColor.toRadixString(16)}')");

          //if res equals zero there's been some kind of error while insterting to db //TODO add tag error handling
          if (res == 0) {
            throw (Exception('Could not add tag into db'));
          }
        }
      }
    }

    if (object is Event) {
      print("adding event");
      query =
          "INSERT INTO Events (title, description, date_added, repeat_mode, date_due) VALUES ('${object.title}', '${object.description}', '$now', '${object.repeatMode == null ? 'NULL' : describeEnum((object).repeatMode!)}',  '${object.dateDue}')";

      res = await (await db).rawInsert(query);

      if (res != 0) {
        //if res != 0 then we can proceed with adding event with tags to db (if there are tags)
        if (tags.isNotEmpty) {
          //if there are tags then the event is added to events with tags table
          for (String tag in tags) {
            tag = tag.replaceAll(" ", "");

            String query = "INSERT INTO EventsWithTags "
                "(tagID, eventID, importance) "
                "VALUES "
                "((SELECT id FROM Tags WHERE name='$tag'), (SELECT id FROM Events WHERE title='${object.title}'), ${importance++})";

            print(query);

            int res = await (await db).rawInsert(query);
            // int res = await (await db).rawInsert(
            //     "INSERT INTO EventsWithTags (tagID, eventID, importance) VALUES ('SELECT id FROM Tags WHERE name='$tag'','SELECT id FROM Events WHERE title='${object.title}'','${importance++}')");

            if (res == 0) {
              throw (Exception(
                  'Problem with adding tag and event to event with tags table'));
            }
          }
        }
      }
    } else {
      print("adding note");
      query =
          "INSERT INTO Notes (title, description, date_added) VALUES ('${object.title}', '${object.description ?? 'NULL'}', '$now')";

      print(query);

      res = await (await db).rawInsert(query);

      if (res != 0) {
        //if res != 0 then we can proceed with adding event with tags to db (if there are tags)
        if (tags.isNotEmpty) {
          //if there are tags then the note is added to notes with tags table
          for (String tag in tags) {
            tag = tag.replaceAll(" ", "");

            String query = "INSERT INTO NotesWithTags "
                "(tagID, noteID, importance) "
                "VALUES "
                "((SELECT id FROM Tags WHERE name='$tag'), (SELECT id FROM Notes WHERE title='${object.title}'), ${importance++})";

            int res = await (await db).rawInsert(query);

            // int res = await (await db).rawInsert(
            //     "INSERT INTO NotesWithTags (tagID, noteID, importance) VALUES ('SELECT id FROM Tags WHERE name='$tag'','SELECT id FROM Notes WHERE title='${object.title}'',${importance++})");

            if (res == 0) {
              throw (Exception(
                  'Problem with adding tag and event to event with tags table'));
            }
          }
        }
      }
    }
    print(query);
    print(res);
    if (res == 0) throw Exception("Couldn't insert into db");
  }

  ///returns map of user activity in current week (number of events marked as finished)
  ///result looks like this {
  /// "1": x, starting at 1, ending at 7 (1 is monday, 7 is sunday)
  ///...
  Future<Map<int, int>> getWeeklyActivity(DateTime day) async {
    Map<int, int> results = {};
    String dashedDay = day.getDashedDate();

    String query = "SELECT ";
    for (var i = 1; i < 8; i++) {
      query +=
          "(SELECT COUNT(Events.id) FROM EVENTS WHERE DATE(date_finished) == DATE('$dashedDay', '-' || strftime('%w','${day.subtract(Duration(days: i)).getDashedDate()}')|| ' day') ) AS '${day.subtract(Duration(days: day.weekday - i)).weekday}' ";
      if (i != 7) query += ",";
    }
    print(query);

    return results;
  }

  ///returns map of user upcoming activity in current month (number of events with date due for days of the month)
  ///result looks like this {
  /// "1": x, starting at 1, ending at month length
  ///...
  Future<Map<int, int>> getMonthlyActivity(DateTime day) async {
    Map<int, int> results = {};
    String dashedDay = day.getDashedDate();

    String query = "SELECT ";
    for (var i = 1; i <= DateTime(day.year, day.month + 1, 0).day; i++) {
      query +=
          "(SELECT COUNT(Events.id) FROM EVENTS WHERE DATE(date_due) == DATE('${day.year}-${day.month}-${i.addLeadingZeros(2)}')) AS '$i' ";
      if (i != DateTime(day.year, day.month + 1, 0).day) query += ",";
    }
    print(query);

    return results;
  }

  ///returns map of user upcoming activity in upcoming 7 days (number of events with date due for the next seven days)
  ///result looks like this {
  /// "1":
  ///...
  Future<Map<int, int>> get upcomingEvents async {
    Map<int, int> results = {};
    DateTime day = DateTime.now();

    String query =
        "SELECT title, description, Events.date_added, date_finished, DATE(date_due), repeat_mode "
        "FROM Events "
        "WHERE date_due BETWEEN '${day.getDashedDate()}' AND '${day.subtract(const Duration(days: 7)).getDashedDate()}'";

    print(query);

    return results;
  }
}
