import 'package:actions_core/src/action.dart';
import 'package:actions_core/src/action_context.dart';
import 'package:pond_core/pond_core.dart';

class ActionCoreComponent with IsCorePondComponent, IsActionContext {
  @override
  final List<Action> actions;

  ActionCoreComponent({required this.actions});
}
