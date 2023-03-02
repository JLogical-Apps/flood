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

  useEffect(
    () {
      _debugQueryRequest(debugDialogContext: debugDialogContext, queryRequest: queryRequest);
      return null;
    },
    [queryRequest, debugDialogContext],
  );

  final queryModel = useMemoized(
    () => queryRequest
        ?.mapIfNonNull((queryRequest) => Model.fromValueStream(dropCoreContext.executeQueryX(queryRequest))),
    [queryRequest],
  );
  useModelOrNull(queryModel);
  return queryModel;
}

Model<T> useQuery<T>(QueryRequest<dynamic, T> queryRequest) {
  return useQueryOrNull(queryRequest)!;
}

Model<T?> useNullableQueryModel<E extends Entity, T>(Model<QueryRequest<E, T>?> queryRequestModel) {
  final context = useContext();
  final dropCoreContext = useDropCoreContext();
  final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);

  useEffect(
    () {
      _debugQueryRequest(debugDialogContext: debugDialogContext, queryRequest: queryRequestModel.getOrNull());
      return null;
    },
    [queryRequestModel.state, debugDialogContext],
  );

  final resultModel = useMemoized(
    () => queryRequestModel.flatMap((queryRequest) => queryRequest?.toModel(dropCoreContext) ?? Model.value(null)),
    [queryRequestModel],
  );
  useModel(resultModel);
  return resultModel;
}

Model<T> useQueryModel<E extends Entity, T>(Model<QueryRequest<E, T>> queryRequestModel) {
  final context = useContext();
  final dropCoreContext = useDropCoreContext();
  final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);

  useEffect(
    () {
      _debugQueryRequest(debugDialogContext: debugDialogContext, queryRequest: queryRequestModel.getOrNull());
      return null;
    },
    [queryRequestModel.state, debugDialogContext],
  );

  final resultModel = useMemoized(
    () => queryRequestModel.flatMap((queryRequest) => queryRequest.toModel(dropCoreContext)),
    [queryRequestModel],
  );
  useModel(resultModel);
  return resultModel;
}

void _debugQueryRequest<T>({
  required DebugDialogContext? debugDialogContext,
  required QueryRequest<dynamic, T>? queryRequest,
}) {
  if (debugDialogContext == null || queryRequest == null) {
    return;
  }

  final newDebugData = debugDialogContext.data.copy();
  final queriesRun =
      newDebugData.putIfAbsent(DropAppComponent.queriesRunField, () => <QueryRequest>[]) as List<QueryRequest>;
  queriesRun.add(queryRequest);
  debugDialogContext.data = newDebugData;
}
