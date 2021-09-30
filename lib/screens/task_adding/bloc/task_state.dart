import 'package:chase_your_goals/data/models/event_repeat_modes.dart';
import 'package:chase_your_goals/data/models/tag.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_submitting_status.dart';
import 'package:equatable/equatable.dart';

class TaskState extends Equatable {
  const TaskState({
    this.title = "",
    this.description,
    this.dueDate,
    this.repeatMode,
    this.status = const InitialTaskFormStatus(),
    this.tags,
  });

  TaskState copyWith({
    String? title,
    String? description,
    TaskSubmittingStatus? status,
    DateTime? dueDate,
    EventRepeatMode? repeatMode,
    String? tags,
  }) =>
      TaskState(
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        dueDate: dueDate ?? this.dueDate,
        repeatMode: repeatMode ?? this.repeatMode,
        tags: tags ?? this.tags,
      );

  @override
  List<Object?> get props =>
      [title, description, status, dueDate, repeatMode, tags];

  final String title;
  final String? description;
  final DateTime? dueDate;
  final EventRepeatMode? repeatMode;
  final TaskSubmittingStatus status;
  final String? tags;
}
