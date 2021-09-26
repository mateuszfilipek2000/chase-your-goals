import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Task {
  Task(
    this.title,
    this.description,
    this.dateAdded,
    this.dateDue,
    this.status,
    this.tags,
  );

  final String title;
  final String? description;
  final DateTime dateAdded;
  final DateTime? dateDue;
  final Status status;
  final List<String> tags;

  //TODO add tag colours to db
  //color is based on added tags, only the first available tag is accounted for
  Color get color {
    //no available tags therefore getter returns default colour
    if (tags.isEmpty) return Colors.blue;
    return Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
  }
}
