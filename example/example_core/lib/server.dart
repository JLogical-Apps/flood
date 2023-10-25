import 'dart:async';

import 'package:example_core/pond.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<dynamic> main(final context) async {
  final corePondContext = await getCorePondContext();
  final name = corePondContext.environmentCoreComponent.get('NAME');
  corePondContext.log('name: $name');
}
