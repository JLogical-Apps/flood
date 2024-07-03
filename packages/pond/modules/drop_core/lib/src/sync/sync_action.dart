import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/state/state.dart';

abstract class SyncAction extends ValueObject {
  void modifyStates(List<State> states) {}

  bool modifies(State state) {
    return false;
  }

  Future<void> onPublish(DropCoreContext context);
}
