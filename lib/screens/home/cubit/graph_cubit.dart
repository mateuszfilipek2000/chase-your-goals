import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit() : super(GraphInitial());
}
