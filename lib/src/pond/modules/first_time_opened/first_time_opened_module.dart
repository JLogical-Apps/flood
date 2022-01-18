import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';

import 'app_opened_marker.dart';
import 'app_opened_marker_entity.dart';

class FirstTimeOpenedModule extends AppModule {
  bool? isFirstTimeOpened;

  Future<void> onLoad() async {
    final existingAppOpenedMarker = await Query.from<AppOpenedMarkerEntity>().firstOrNull().get();
    isFirstTimeOpened = existingAppOpenedMarker == null;

    if (isFirstTimeOpened!) {
      final appOpenedMarker = AppOpenedMarker();
      final deviceInfoEntity = AppOpenedMarkerEntity()..value = appOpenedMarker;

      await deviceInfoEntity.create();
    }
  }

  @override
  Future<void> onReset() async {
    final allMarkers = await Query.from<AppOpenedMarkerEntity>().all().get();
    for (final marker in allMarkers) {
      await marker.delete();
    }
  }
}
