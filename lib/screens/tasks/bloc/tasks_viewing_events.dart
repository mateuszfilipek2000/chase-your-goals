abstract class TaskViewingEvent {
  const TaskViewingEvent();
}

class TaskViewingRequestNotes extends TaskViewingEvent {
  final int page;

  const TaskViewingRequestNotes({this.page = 1});
}

class TaskViewingRequestEvents extends TaskViewingEvent {}
