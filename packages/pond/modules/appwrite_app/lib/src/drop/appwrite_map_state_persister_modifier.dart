import 'dart:convert';

import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';

class AppwriteMapStatePersisterModifier extends StatePersisterModifier {
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
    return data
        .copy()
        .replaceWhereTraversed(
          (key, value) => value is String && value.startsWith('{') && value.endsWith('}'),
          (key, value) => jsonDecode(value) as Map,
        )
        .cast<String, dynamic>();
  }
}
