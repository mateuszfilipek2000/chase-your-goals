abstract class TaskViewingEvent {
  const TaskViewingEvent();
}

class TaskViewingRequestNotes extends TaskViewingEvent {
  final int page;
  final String? query;

  const TaskViewingRequestNotes({this.page = 1, this.query});
}

class TaskViewingRequestEvents extends TaskViewingEvent {
  final int page;
  final String? query;

  const TaskViewingRequestEvents({this.page = 1, this.query});
}

class TaskViewingSearch extends TaskViewingEvent {
  final String query;

  const TaskViewingSearch(this.query);
}
