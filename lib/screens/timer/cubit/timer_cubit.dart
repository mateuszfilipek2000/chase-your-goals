import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerState(0, 0, 0));

  void incrementHours({int? minutes}) {
    if (state.hours + 1 <= 99) {
      emit(
          TimerState(state.hours + 1, minutes ?? state.minutes, state.seconds));
    }
  }

  void decrementHours() {
    if (state.hours - 1 >= 0) {
      emit(TimerState(state.hours - 1, state.minutes, state.seconds));
    }
  }

  void incrementMinutes({int? seconds}) {
    if (state.minutes + 1 < 60) {
      emit(
          TimerState(state.hours, state.minutes + 1, seconds ?? state.seconds));
    } else if (state.minutes + 1 == 60) {
      incrementHours(minutes: 0);
    }
  }

  void decrementMinutes() {
    if (state.minutes - 1 >= 0) {
      emit(TimerState(state.hours, state.minutes - 1, state.seconds));
    }
  }

  void incrementSeconds() {
    if (state.seconds + 1 < 60) {
      emit(TimerState(state.hours, state.minutes, state.seconds + 1));
    } else if (state.seconds + 1 == 60) {
      incrementMinutes(seconds: 0);
    }
  }

  void decrementSeconds() {
    if (state.seconds - 1 >= 0) {
      emit(TimerState(state.hours, state.minutes, state.seconds - 1));
    }
  }
}

class TimerState extends Equatable {
  const TimerState(this.hours, this.minutes, this.seconds);
  final int hours;
  final int minutes;
  final int seconds;

  @override
  List<Object?> get props => [hours, minutes, seconds];
}
