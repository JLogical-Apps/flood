import 'package:debug_dialog/debug_dialog.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

DropCoreContext useDropCoreContext() {
  return useMemoized(() => useAppPondContext().find<DropCoreComponent>());
}

Model<T>? useQueryOrNull<T>(QueryRequest<T>? queryRequest) {
  final dropCoreContext = useDropCoreContext();
  final queryModel = useMemoized(
    () => queryRequest
        ?.mapIfNonNull((queryRequest) => Model.fromValueStream(dropCoreContext.executeQueryX(queryRequest))),
    [queryRequest],
  );
  useModelOrNull(queryModel);
  return queryModel;
}

Model<T> useQuery<T>(QueryRequest<T> queryRequest) {
  return useQueryOrNull(queryRequest)!;
}

Model<T?> useNullableQueryModel<T>(Model<QueryRequest<T>?> queryRequestModel) {
  final context = useContext();
  final dropCoreContext = useDropCoreContext();

  useEffect(
    () {
      final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);
      if (debugDialogContext == null) {
        return;
      }

      queryRequestModel.state.ifPresent((queryRequest) {
        final newDebugData = debugDialogContext.data.copy();
        final queriesRun = newDebugData.putIfAbsent('queriesRun', () => <String>[]) as List<String>;
        queriesRun.add(queryRequest.toString());
        debugDialogContext.data = newDebugData;
      });

      return null;
    },
    [queryRequestModel.state],
  );

  final resultModel = useMemoized(
    () => queryRequestModel.flatMap((queryRequest) => queryRequest?.toModel(dropCoreContext) ?? Model.value(null)),
    [queryRequestModel],
  );
  useModel(resultModel);
  return resultModel;
}

Model<T> useQueryModel<T>(Model<QueryRequest<T>> queryRequestModel) {
  final context = useContext();
  final dropCoreContext = useDropCoreContext();

  useEffect(
    () {
      final debugDialogContext = Provider.of<DebugDialogContext?>(context, listen: false);
      if (debugDialogContext == null) {
        return;
      }

      queryRequestModel.state.ifPresent((queryRequest) {
        final queriesRun = debugDialogContext.data.putIfAbsent('queriesRun', () => <String>[]) as List<String>;
        queriesRun.add(queryRequest.toString());
      });

      return null;
    },
    [queryRequestModel.state],
  );

  final resultModel = useMemoized(
    () => queryRequestModel.flatMap((queryRequest) => queryRequest.toModel(dropCoreContext)),
    [queryRequestModel],
  );
  useModel(resultModel);
  return resultModel;
}
