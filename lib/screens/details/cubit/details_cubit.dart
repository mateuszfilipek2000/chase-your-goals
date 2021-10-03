import 'package:bloc/bloc.dart';
    
class DetailsCubit extends Cubit<int> {
DetailsCubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    