import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/state/state.dart';

abstract class Stateful {
  State getState(CoreDropContext context);

  State getStateUnsafe(CoreDropContext context);
}
