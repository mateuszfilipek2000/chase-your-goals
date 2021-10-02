import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_state.dart';

class Note {
  const Note(
    this.title,
    this.description,
    this.dateAdded,
    this.dateFinished, {
    this.tags,
    this.color,
  });
  final String title;
  final String? description;
  final DateTime dateAdded;
  final DateTime? dateFinished;
  final String? tags;
  final String? color;

  factory Note.fromTaskState(TaskState state) => Note(
        state.title,
        state.description,
        DateTime.now(),
        null,
        tags: state.tags,
      );
}
