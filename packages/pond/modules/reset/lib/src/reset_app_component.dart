import 'package:debug/debug.dart';
import 'package:pond/pond.dart';
import 'package:reset/src/debug/reset_debug_component.dart';
import 'package:reset/src/debug/reset_debug_page.dart';

class ResetAppComponent with IsAppPondComponent, IsDebugPageComponentWrapper {
  static const queriesRunField = 'queriesRun';

  @override
  List<AppPage<AppPage>> get pages => [
        ResetDebugPage(),
      ];

  @override
  DebugPageComponent get debugPageComponent => ResetDebugComponent();
}
