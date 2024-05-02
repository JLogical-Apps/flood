import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style_component/src/entity_search_result_override.dart';

class PortStyleAppComponent with IsAppPondComponent {
  final List<StyledObjectPortOverride> portOverrides;
  final List<StyledSearchResultOverride> searchResultOverrides;

  PortStyleAppComponent({
    this.portOverrides = const [],
    this.searchResultOverrides = const [],
  });

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return StyledObjectPortOverridesProvider(
      overrides: StyledObjectPortOverrides(overrides: portOverrides),
      child: StyledSearchResultOverridesProvider(
        overrides: StyledSearchResultOverrides(
          overrides: [
            ...searchResultOverrides,
            EntitySearchResultOverride(),
          ],
        ),
        child: app,
      ),
    );
  }
}
