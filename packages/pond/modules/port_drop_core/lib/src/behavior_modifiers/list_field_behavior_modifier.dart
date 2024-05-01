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
          if (runtimeType != null &&
              runtimeType.isConcrete &&
              runtimeType.isA(dropContext.getRuntimeType<ValueObject>())) {
            final valueObject = value ?? runtimeType.createInstance() as ValueObject;
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
}
