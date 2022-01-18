import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/first_time_opened/app_opened_marker_repository.dart';

import 'app_opened_marker.dart';
import 'app_opened_marker_entity.dart';

class FirstTimeOpenedModule extends AppModule {
  final Directory baseDirectory;

  bool? isFirstTimeOpened;

  FirstTimeOpenedModule({required this.baseDirectory});

  @override
  void onRegister(AppRegistration registration) {
    registration.register(AppOpenedMarkerRepository(baseDirectory: baseDirectory));
  }

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
