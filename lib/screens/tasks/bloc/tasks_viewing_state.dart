import 'package:chase_your_goals/core/constants/content_type.dart';
import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/data/models/task.dart';

abstract class TaskViewingState {
  const TaskViewingState();
}

class TaskViewingInitial extends TaskViewingState {}

class TaskViewingLoading extends TaskViewingState {}

class TaskViewingLoadingSuccess extends TaskViewingState {
  final List<Note> tasks;
  final bool canLoadMore;
  final ContentType contentType;

  const TaskViewingLoadingSuccess(
    this.tasks,
    this.contentType, {
    this.canLoadMore = false,
  });
}

class TaskViewingLoadingFailure extends TaskViewingState {
  final Exception exception;

  const TaskViewingLoadingFailure(this.exception);
}
