import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import 'config_module.dart';

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
