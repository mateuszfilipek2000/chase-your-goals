abstract class TaskSubmittingStatus {
  const TaskSubmittingStatus();
}

class InitialTaskFormStatus extends TaskSubmittingStatus {
  const InitialTaskFormStatus();
}

class TaskSubmitting extends TaskSubmittingStatus {
  const TaskSubmitting();
}

class TaskSubmittingSuccess extends TaskSubmittingStatus {
  const TaskSubmittingSuccess();
}

class TaskSubmittingFailure extends TaskSubmittingStatus {
  final Exception exception;

  const TaskSubmittingFailure(this.exception);
}
