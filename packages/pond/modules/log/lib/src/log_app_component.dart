import 'package:debug/debug.dart';
import 'package:log/src/log_debug_page.dart';
import 'package:pond/pond.dart';

class LogAppComponent with IsAppPondComponent, IsDebugPageComponent {
  @override
  String get name => 'View Logs';

  @override
  AppPage get appPage => LogDebugPage();

  @override
  List<AppPage> get pages => [LogDebugPage()];
}
