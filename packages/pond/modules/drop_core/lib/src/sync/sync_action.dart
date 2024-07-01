import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';

abstract class SyncAction extends ValueObject {
  Future<void> onPublish(DropCoreContext context);
}
