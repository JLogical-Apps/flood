import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';
import 'package:port_core/src/suggestions_port_field.dart';

class SuggestionsPortFieldNodeModifier extends WrapperPortFieldNodeModifier<SuggestionsPortField> {
  SuggestionsPortFieldNodeModifier({required super.modifierGetter});

  @override
  SuggestionsPortField? findSuggestionsPortFieldOrNull(SuggestionsPortField portField) {
    return portField;
  }
}
