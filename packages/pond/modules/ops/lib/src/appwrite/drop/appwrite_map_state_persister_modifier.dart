import 'dart:convert';

import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteMapStatePersisterModifier extends StatePersisterModifier {
  final StatePersister<Map<String, dynamic>> Function() statePersisterGetter;

  AppwriteMapStatePersisterModifier({required this.statePersisterGetter});

  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    return data
        .copy()
        .replaceWhereTraversed(
          (key, value) => value is Map,
          (key, value) => jsonEncode(value as Map),
        )
        .cast<String, dynamic>();
  }

  @override
  Map<String, dynamic> inflate(Map<String, dynamic> data) {
    return data.copy().replaceWhereTraversed(
      (key, value) => value is String && value.startsWith('{') && value.endsWith('}'),
      (key, value) {
        final valueData = jsonDecode(value) as Map;
        final isState = valueData.containsKey('_type');
        if (!isState) {
          return valueData;
        }

        return statePersisterGetter().inflate(valueData.cast<String, dynamic>());
      },
    ).cast<String, dynamic>();
  }
}
