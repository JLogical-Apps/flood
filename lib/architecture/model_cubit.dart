import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/architecture/model_state.dart';

abstract class ModelCubit<T> extends Cubit<ModelState<T>> {
  ModelCubit() : super(ModelLoadingState<T>());
}
