import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_state.dart';

class Note {
  const Note(
    this.title,
    this.description,
    this.dateAdded,
    this.dateFinished,
    this.status,
  );
  final String title;
  final String? description;
  final DateTime dateAdded;
  final DateTime? dateFinished;
  final NoteStatus status;

  factory Note.fromTaskState(TaskState state) => Note(
        state.title,
        state.description,
        DateTime.now(),
        null,
        NoteStatus.inProgress,
      );
}
