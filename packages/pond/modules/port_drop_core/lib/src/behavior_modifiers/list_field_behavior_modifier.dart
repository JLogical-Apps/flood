import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/behavior_modifiers/value_object_field_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class ListFieldBehaviorModifier extends PortGeneratorBehaviorModifier<ListValueObjectProperty> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  ListFieldBehaviorModifier({required this.modifierGetter});

  @override
  Map<String, PortField> getPortFieldByName(
    ListValueObjectProperty behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {
      behavior.name: PortField.list<dynamic, dynamic>(
        initialValues: behavior.value.nullIfEmpty ?? defaultValue,
        itemPortFieldGenerator: (value) {
          final dropContext = context.corePondContext.dropCoreComponent;
          final runtimeType = dropContext.getRuntimeTypeOrNullRuntime(behavior.valueType);
          if (runtimeType != null && runtimeType.isA(dropContext.getRuntimeType<ValueObject>())) {
            var valueObject = extractValueObject(context, value: value);
            valueObject ??= runtimeType.createInstanceOrNull() as ValueObject?;
            return ValueObjectFieldBehaviorModifier.getValueObjectPortField(
              context,
              initialValue: valueObject,
              isRequiredOnEdit: true,
              valueObjectType: behavior.valueType,
              modifierGetter: modifierGetter,
            );
          }

          return SimplePortField(value: value, dataType: behavior.valueType, submitType: behavior.valueType);
        },
      )
    };
  }

  ValueObject? extractValueObject(PortGeneratorBehaviorModifierContext context, {required dynamic value}) {
    if (value is ValueObject) {
      return value;
    }

    if (value is StageValue) {
      final port = value.port;
      final runtimeType = value.value as RuntimeType?;
      if (port == null || runtimeType == null) {
        return null;
      }

      return context.corePortDropComponent.getValueObjectFromPort(
        port: port,
        valueObjectType: runtimeType.type,
      );
    }

    return null;
  }
}
