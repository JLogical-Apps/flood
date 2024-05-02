import 'package:flutter/material.dart';
import 'package:port_style/src/styled_search_result_overrides.dart';
import 'package:provider/provider.dart';

class StyledSearchResultOverridesProvider extends StatelessWidget {
  final StyledSearchResultOverrides overrides;
  final Widget child;

  StyledSearchResultOverridesProvider({required this.overrides, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<StyledSearchResultOverrides>(
      create: (_) => overrides,
      child: child,
    );
  }
}
