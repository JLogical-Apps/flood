import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/architecture/model_state.dart';

abstract class ModelCubit<T> extends Cubit<ModelState<T>> {
  ModelCubit({T? initialModel}) : super(initialModel == null ? ModelLoadingState<T>() : ModelLoadedState<T>(model: initialModel));

  /// Emits a loading state.
  void emitLoading() {
    emit(ModelLoadingState());
  }

  /// Emits a loaded state.
  void emitLoaded(T model) {
    emit(ModelLoadedState(model: model));
  }

  /// Emits an error state.
  void emitError([dynamic error]) {
    emit(ModelErrorState(error: error));
  }
}
