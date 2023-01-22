import 'package:drop_core/drop_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
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
