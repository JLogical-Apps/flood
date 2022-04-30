import 'dart:convert';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/with_mapper_data_source.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

class JsonDataSourceMapper extends DataSource<Map<String, dynamic>>
    with WithMapperDataSource<String, Map<String, dynamic>> {
  final DataSource<String> parent;

  JsonDataSourceMapper({required this.parent});

  @override
  String saveMapped(Map<String, dynamic> obj) {
    return json.encode(obj);
  }

  @override
  Map<String, dynamic>? loadMapped(String? obj) {
    return obj.mapIfNonNull((obj) => json.decode(obj));
  }
}
