import 'package:bloc/bloc.dart';
    
class CalendarCubit extends Cubit<int> {
CalendarCubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    