import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortGeneratorBehaviorModifier<T extends ValueObjectBehavior>
    with IsTypedModifier<T, ValueObjectBehavior> {
  Map<String, PortField> getPortFieldByName(T behavior);
}

abstract class WrapperPortGeneratorBehaviorModifier<T extends ValueObjectBehavior>
    extends PortGeneratorBehaviorModifier<T> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  WrapperPortGeneratorBehaviorModifier({required this.modifierGetter});

  ValueObjectBehavior unwrapBehavior(T behavior);

  PortField getPortField(T behavior, PortField sourcePortField) {
    return sourcePortField;
  }

  @override
  Map<String, PortField> getPortFieldByName(ValueObjectBehavior behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior as T);
    final subModifier = modifierGetter(unwrappedBehavior);
    if (subModifier == null) {
      return {};
    }

    final subPortFieldByName = subModifier.getPortFieldByName(unwrappedBehavior);
    return subPortFieldByName.mapValues((name, portField) => getPortField(behavior, portField));
  }
}
