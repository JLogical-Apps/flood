import 'package:debug/debug.dart';
import 'package:drop/src/drop_app_component.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

DropCoreContext useDropCoreContext() {
  return useMemoized(() => useAppPondContext().find<DropCoreComponent>());
}

Model<T>? useQueryOrNull<T>(QueryRequest<dynamic, T>? queryRequest) {
  final context = useContext();
  final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);
  final dropCoreContext = useDropCoreContext();

  final queryModel = useMemoized(
    () => queryRequest
        ?.mapIfNonNull((queryRequest) => Model.fromValueStream(dropCoreContext.executeQueryX(queryRequest))),
    [queryRequest],
  );

  final result = useModelOrNull(queryModel);

  useEffect(
    () {
      _debugQueryRequest(
        debugDialogContext: debugDialogContext,
        queryRequest: queryRequest,
        value: result,
      );
      return null;
    },
    [queryRequest, debugDialogContext, result],
  );

  return queryModel;
}

Model<T> useQuery<T>(QueryRequest<dynamic, T> queryRequest) {
  return useQueryOrNull(queryRequest)!;
}

Model<T?> useNullableQueryModel<E extends Entity, T>(Model<QueryRequest<E, T>?> queryRequestModel) {
  final context = useContext();
  final dropCoreContext = useDropCoreContext();
  final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);

  final resultModel = useMemoized(
    () => queryRequestModel.flatMap((queryRequest) => queryRequest?.toModel(dropCoreContext) ?? Model.value(null)),
    [queryRequestModel],
  );
  final result = useModel(resultModel);

  useEffect(
    () {
      _debugQueryRequest(
        debugDialogContext: debugDialogContext,
        queryRequest: queryRequestModel.getOrNull(),
        value: result,
      );
      return null;
    },
    [queryRequestModel.state, debugDialogContext, result],
  );

  return resultModel;
}

Model<T> useQueryModel<E extends Entity, T>(Model<QueryRequest<E, T>> queryRequestModel) {
  final context = useContext();
  final dropCoreContext = useDropCoreContext();
  final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);

  final resultModel = useMemoized(
    () => queryRequestModel.flatMap((queryRequest) => queryRequest.toModel(dropCoreContext)),
    [queryRequestModel],
  );
  final result = useModel(resultModel);

  useEffect(
    () {
      _debugQueryRequest(
        debugDialogContext: debugDialogContext,
        queryRequest: queryRequestModel.getOrNull(),
        value: result,
      );
      return null;
    },
    [queryRequestModel.state, debugDialogContext, result],
  );

  return resultModel;
}

void _debugQueryRequest({
  required DebugDialogContext? debugDialogContext,
  required QueryRequest? queryRequest,
  required FutureValue? value,
}) {
  if (debugDialogContext == null || queryRequest == null || value == null) {
    return;
  }

  final newDebugData = debugDialogContext.data.copy();
  final queryResultToValue = newDebugData.putIfAbsent(
      DropAppComponent.queriesRunField, () => <QueryRequest, FutureValue>{}) as Map<QueryRequest, FutureValue>;
  queryResultToValue[queryRequest] = value;
  debugDialogContext.data = newDebugData;
}
