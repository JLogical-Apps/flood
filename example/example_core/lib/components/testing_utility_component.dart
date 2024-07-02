import 'package:flood_core/flood_core.dart';

class TestingUtilityComponent with IsCorePondComponent, IsCorePondComponentBehavior {
  late bool useSyncing;

  @override
  Future onRegister(CorePondContext context, CorePondComponent component) async {
    useSyncing = await context.environmentCoreComponent.getOrDefault('useSyncing', fallback: () => false);
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [this];
}

extension TestingCorePondContextExtensions on CorePondContext {
  TestingUtilityComponent get testingComponent => locate<TestingUtilityComponent>();
}
