import 'package:chase_your_goals/data/models/task_status.dart';

class Task {
  Task(this.title, this.description, this.dateAdded, this.dateDue, this.status);

  final String title;
  final String? description;
  final DateTime dateAdded;
  final DateTime? dateDue;
  final Status status;
}
