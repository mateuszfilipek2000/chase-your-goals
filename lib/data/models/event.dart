import 'package:chase_your_goals/data/models/event_repeat_modes.dart';
import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_state.dart';

class Event extends Note {
  const Event(
    String title,
    String? description,
    DateTime dateAdded,
    DateTime? dateFinished,
    this.dateDue,
    this.repeatMode, {
    String? color,
    String? tags,
  }) : super(
          title,
          description,
          dateAdded,
          dateFinished,
          color: color,
          tags: tags,
        );

  final DateTime dateDue;
  final EventRepeatMode? repeatMode;

  //in order for this constructor to work properly make sure that
  //task state has non null due date parameter
  factory Event.fromTaskState(TaskState state) => Event(
        state.title,
        state.description,
        DateTime.now(),
        null,
        state.dueDate!,
        state.repeatMode,
      );
}
