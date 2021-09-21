import 'package:bloc/bloc.dart';
    
class AboutCubit extends Cubit<int> {
AboutCubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    