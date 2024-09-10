import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class SuggestionsPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<SuggestionsValueObjectProperty> {
  @override
  PortField? getPortField(
    SuggestionsValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return sourcePortField.withSuggestions(
      (value) async => await behavior.getSuggestions(context.corePondContext.dropCoreComponent, value),
    );
  }
}
