import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/architecture/query_list_response.dart';
import 'package:jlogical_utils/utils/pair.dart';

import 'multi_model_state.dart';

abstract class MultiModelCubit<M> extends Cubit<MultiModelState<M>> {
  /// The cursor for the last request.
  dynamic _cursor;
  dynamic get cursor => _cursor;

  /// The command to run when [loadNext] is run.
  /// If [restart], restarts the query.
  Future<void> Function({bool restart}) _referenceCommand;

  MultiModelCubit() : super(MultiModelInitialState<M>());

  /// Loads models using a query list response.
  /// If [refresh], restarts the query.
  /// If [amount] is null, uses the initial amount.
  Future<void> loadModels(Future<QueryListResponse<Pair<String, M>, dynamic>> queryListResponse(), {bool restart}) async {
    if (restart) _cursor = null;
    _referenceCommand = ({bool restart}) async => loadModels(
          queryListResponse,
          restart: restart,
        );
    await _loadModels(
      queryListResponse,
      restart,
    );
  }

  /// Loads the next models from the previous request.
  Future<void> loadNext() async {
    if (_referenceCommand == null) {
      print('Null reference command in MultiModelCubit');
      return;
    }
    await _referenceCommand(restart: false);
  }

  /// Restarts the query.
  Future<void> restart() async {
    if (_referenceCommand == null) {
      print('Null reference command in MultiModelCubit');
      return;
    }
    await _referenceCommand(restart: true);
  }

  Future<void> _loadModels(Future<QueryListResponse<Pair<String, M>, dynamic>> queryListResponse(), bool refresh) async {
    var state = this.state;
    Map<String, M> currentIDToCompletedOrdersMap = {};

    if (!refresh && state is MultiModelLoadedState<M>) {
      currentIDToCompletedOrdersMap = state.idToModelMap;

      emit(MultiModelLoadedState(
        idToModelMap: state.idToModelMap,
        isLoading: true,
        canLoadMore: state.canLoadMore,
      ));
    } else if (state is MultiModelErrorState<M>) {
      emit(MultiModelInitialState<M>());
    }

    try {
      var completedOrdersResult = await queryListResponse();

      _cursor = completedOrdersResult.cursor;

      var idToModelMap = Map.fromEntries([...currentIDToCompletedOrdersMap.entries] + [...completedOrdersResult.data.map((pair) => MapEntry<String, M>(pair.first, pair.second))]);

      emit(MultiModelLoadedState<M>(
        idToModelMap: idToModelMap,
        canLoadMore: cursor != null,
        isLoading: false,
      ));
    } catch (e) {
      print(e);
      emit(MultiModelErrorState<M>());
    }
  }
}
