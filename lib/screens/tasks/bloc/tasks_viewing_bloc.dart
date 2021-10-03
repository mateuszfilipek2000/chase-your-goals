import 'package:chase_your_goals/core/constants/content_type.dart';
import 'package:chase_your_goals/data/models/event.dart';
import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/data/repositories/database_repository.dart';
import 'package:chase_your_goals/screens/tasks/bloc/tasks_viewing_events.dart';
import 'package:chase_your_goals/screens/tasks/bloc/tasks_viewing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskViewingBloc extends Bloc<TaskViewingEvent, TaskViewingState> {
  TaskViewingBloc(this.databaseRepository) : super(TaskViewingInitial()) {
    on<TaskViewingRequestNotes>(
      (event, emit) async {
        try {
          emit(TaskViewingLoading());
          List<Note> notes = await databaseRepository.getNotes();
          emit(
            TaskViewingLoadingSuccess(
              notes,
              ContentType.notes,
            ),
          );
        } catch (e) {
          emit(TaskViewingLoadingFailure(Exception("Whoops")));
          //print(e);
        }
      },
    );
    on<TaskViewingRequestEvents>(
      (event, emit) async {
        try {
          emit(TaskViewingLoading());
          List<Event> events = await databaseRepository.getEvents();
          emit(
            TaskViewingLoadingSuccess(
              events,
              ContentType.events,
            ),
          );
        } catch (e) {
          emit(
            TaskViewingLoadingFailure(
              Exception("Could not load events"),
            ),
          );
        }
      },
    );
  }

  final DatabaseRepository databaseRepository;
}
