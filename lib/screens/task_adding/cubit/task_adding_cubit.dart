import 'package:bloc/bloc.dart';
    
class Task_addingCubit extends Cubit<int> {
Task_addingCubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    