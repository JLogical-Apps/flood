import 'package:collection/collection.dart';
import 'package:port_style/src/styled_search_result_override.dart';

class StyledSearchResultOverrides {
  final List<StyledSearchResultOverride> overrides;

  StyledSearchResultOverrides({required this.overrides});

  StyledSearchResultOverride? getOverrideOrNull(dynamic result) {
    return overrides.firstWhereOrNull((override) => override.passes(result));
  }
}
