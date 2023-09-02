import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/state.dart';

abstract class Stateful {
  State getState(DropCoreContext context);

  State getStateUnsafe(DropCoreContext context);
}
