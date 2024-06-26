import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortGeneratorBehaviorModifier<T extends ValueObjectBehavior>
    with IsTypedModifier<T, ValueObjectBehavior> {
  Map<String, PortField> getPortFieldByName(T behavior, PortGeneratorBehaviorModifierContext context);

  dynamic getHintOrNull(T behavior) {
    return null;
  }

  bool isRequiredOnEdit(T behavior) {
    return false;
  }

  bool isOnlyDate(T behavior) {
    return false;
  }

  dynamic getDefaultValue(T behavior) {
    return null;
  }
}

abstract class WrapperPortGeneratorBehaviorModifier<T extends ValueObjectBehavior>
    extends PortGeneratorBehaviorModifier<T> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  WrapperPortGeneratorBehaviorModifier({required this.modifierGetter});

  ValueObjectBehavior unwrapBehavior(T behavior);

  PortField? getPortField(
    T behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField;
  }

  @override
  Map<String, PortField> getPortFieldByName(
    ValueObjectBehavior behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final unwrappedBehavior = unwrapBehavior(behavior as T);
    final subModifier = modifierGetter(unwrappedBehavior);
    if (subModifier == null) {
      return {};
    }

    final subPortFieldByName = subModifier.getPortFieldByName(unwrappedBehavior, context);
    return subPortFieldByName
        .mapValues((name, portField) => getPortField(behavior, portField, context))
        .where((name, portField) => portField != null)
        .mapValues((name, portField) => portField!);
  }

  @override
  dynamic getHintOrNull(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.getHintOrNull(unwrappedBehavior);
  }

  @override
  bool isRequiredOnEdit(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.isRequiredOnEdit(unwrappedBehavior) ?? false;
  }

  @override
  bool isOnlyDate(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.isOnlyDate(unwrappedBehavior) ?? false;
  }

  @override
  dynamic getDefaultValue(T behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior);
    return modifierGetter(unwrappedBehavior)?.getDefaultValue(unwrappedBehavior);
  }
}
