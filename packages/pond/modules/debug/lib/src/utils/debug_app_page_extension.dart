import 'package:debug/src/page/debug_page.dart';
import 'package:pond/pond.dart';

extension DebugAppPageExtension<R extends Route> on AppPage<R> {
  AppPage<R> withDebugParent() {
    return withParent((context, route) => DebugRoute());
  }
}
