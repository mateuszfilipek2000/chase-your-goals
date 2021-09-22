import 'package:bloc/bloc.dart';
    
class TasksCubit extends Cubit<int> {
TasksCubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    