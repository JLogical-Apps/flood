import 'package:actions_core/src/action.dart';
import 'package:actions_core/src/locator/wrapper_action_locator_wrapper.dart';
import 'package:collection/collection.dart';

abstract class ActionLocatorWrapper {
  bool shouldWrap(Action component);

  List<Action> getSubcomponents(Action component);

  static final List<ActionLocatorWrapper> _wrappers = [
    WrapperActionLocatorWrapper(),
  ];

  static ActionLocatorWrapper? getWrapperOrNull(Action action) {
    return _wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(action));
  }

  static List<Action> getSubcomponentsOf(Action component) {
    return getWrapperOrNull(component)?.getSubcomponents(component) ?? [];
  }
}
