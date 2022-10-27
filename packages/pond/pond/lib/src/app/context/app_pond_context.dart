import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond_core/pond_core.dart';

class AppPondContext {
  final List<AppPondComponent> appComponents;

  final CorePondContext corePondContext;

  AppPondContext({required this.corePondContext, List<AppPondComponent>? appComponents})
      : appComponents = appComponents ?? [];

  Future<void> load() async {
    await corePondContext.load();
  }
}
