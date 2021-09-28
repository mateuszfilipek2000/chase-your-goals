import 'package:bloc/bloc.dart';
    
class TimerCubit extends Cubit<int> {
TimerCubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    