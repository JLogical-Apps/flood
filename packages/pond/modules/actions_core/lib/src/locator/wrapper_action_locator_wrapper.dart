import 'package:actions_core/actions_core.dart';
import 'package:actions_core/src/locator/action_locator_wrapper.dart';

class WrapperActionLocatorWrapper extends ActionLocatorWrapper {
  @override
  bool shouldWrap(Action component) {
    return component is ActionWrapper;
  }

  @override
  List<Action> getSubcomponents(Action component) {
    final wrapper = component as ActionWrapper;
    final wrappedAction = wrapper.action;
    return ActionLocatorWrapper.getWrapperOrNull(wrappedAction)?.getSubcomponents(wrappedAction) ?? [wrappedAction];
  }
}
