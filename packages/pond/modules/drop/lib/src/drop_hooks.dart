import 'package:drop_core/drop_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';

DropCoreContext useDropCoreContext() {
  return useAppPondContext().find<DropCoreContext>();
}

Model<T> useQuery<T>(QueryRequest<T> queryRequest) {
  final dropCoreContext = useDropCoreContext();
  final queryModel = useMemoized(() => Model.fromValueStream(stateX: dropCoreContext.executeQueryX(queryRequest)));
  useModel(queryModel);
  return queryModel;
}
