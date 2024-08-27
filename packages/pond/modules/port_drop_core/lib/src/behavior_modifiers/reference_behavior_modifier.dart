import 'package:collection/collection.dart';
import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class ReferenceBehaviorModifier extends PortGeneratorBehaviorModifier<ReferenceValueObjectProperty> {
  @override
  Map<String, PortField> getPortFieldByName(
    ReferenceValueObjectProperty behavior,
    PortGeneratorBehaviorModifierContext context,
  ) {
    final defaultValue =
        BehaviorMetaModifier.getModifier(context.originalBehavior)?.getDefaultValue(context.originalBehavior);
    return {
      behavior.name: PortField.search<Entity?, String?>(
        searchX: () => behavior.getSearchResultsX(context.corePondContext.dropCoreComponent),
        valueMapper: (entity) => entity?.id,
        resultsMapper: (id, entities) => entities.firstWhereOrNull((entity) => entity?.id == id),
        initialValue: behavior.value ?? defaultValue,
        stringSearchMapper:
            !behavior.hasSearch ? null : (entity) => entity == null ? [] : behavior.getSearchString(entity),
      )
    };
  }
}
