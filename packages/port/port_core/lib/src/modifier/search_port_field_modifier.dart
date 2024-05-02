import 'package:port_core/src/modifier/port_field_node_modifier.dart';
import 'package:port_core/src/search_port_field.dart';

class SearchPortFieldNodeModifier extends PortFieldNodeModifier<SearchPortField> {
  @override
  SearchPortField? findSearchPortFieldOrNull(SearchPortField portField) {
    return portField;
  }
}
