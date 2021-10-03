import 'package:flutter_bloc/flutter_bloc.dart';

class SortingOptionCubit extends Cubit<SortingOptionState> {
  SortingOptionCubit() : super(const SortingOptionNotes());

  void changeSortingOption() {
    if (state is SortingOptionNotes) {
      emit(const SortingOptionEvents());
    } else {
      emit(const SortingOptionNotes());
    }
  }
}

abstract class SortingOptionState {
  const SortingOptionState();
}

class SortingOptionNotes extends SortingOptionState {
  const SortingOptionNotes();
}

class SortingOptionEvents extends SortingOptionState {
  const SortingOptionEvents();
}
