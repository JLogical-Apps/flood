import 'package:jlogical_utils/jlogical_utils.dart';

class ConfigDataSource extends DataSource<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>?> getData() async {
    return locate<ConfigModule>().ensureConfigLoaded();
  }

  @override
  Future<void> saveData(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }
}
