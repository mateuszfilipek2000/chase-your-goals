import 'dart:async';

import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:chase_your_goals/data/repositories/database_repository.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_events.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_state.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_submitting_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskAddingBloc extends Bloc<TaskEvent, TaskState> {
  TaskAddingBloc(this.databaseRepository) : super(const TaskState()) {
    on<TitleChanged>((event, emit) => emit(state.copyWith(title: event.title)));
    on<DescriptionChanged>(
        (event, emit) => emit(state.copyWith(description: event.description)));
    on<DateDueChanged>(
        (event, emit) => emit(state.copyWith(dueDate: event.dateDue)));
    on<RepeatModeChanged>(
        (event, emit) => emit(state.copyWith(repeatMode: event.repeatMode)));
    on<TagsChanged>(
      (event, emit) => emit(state.copyWith(tags: event.tags)),
    );
    on<TaskSubmitted>((event, emit) {
      emit(state.copyWith(status: const TaskSubmitting()));

      try {
        databaseRepository.addTask(
          Note(
            state.title,
            state.description,
            DateTime.now(),
            null,
            NoteStatus.inProgress,
          ),
        );
        emit(state.copyWith(status: const TaskSubmittingSuccess()));
      } catch (e) {
        if (e.runtimeType == Exception)
          emit(state.copyWith(status: TaskSubmittingFailure(e as Exception)));
      }
    });
  }

  final DatabaseRepository databaseRepository;
}
