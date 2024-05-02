import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class ReferenceBehaviorModifier extends PortGeneratorBehaviorModifier<ReferenceValueObjectProperty> {
  final PortGeneratorBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  ReferenceBehaviorModifier({required this.modifierGetter});

  @override
  Map<String, PortField> getPortFieldByName(
    ReferenceValueObjectProperty behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue = modifierGetter(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {
      behavior.name: PortField.search<Entity?, String?>(
        search: () => Query.fromRuntime(behavior.entityType).all().get(context.corePondContext.dropCoreComponent),
        valueMapper: (entity) => entity?.id,
        resultsMapper: (id, entities) => entities.firstWhere((entity) => entity?.id == id),
        initialValue: behavior.value ?? defaultValue,
      )
    };
  }
}
