import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'app_opened_marker.dart';
import 'app_opened_marker_entity.dart';

class AppOpenedMarkerRepository extends DefaultAdaptingRepository<AppOpenedMarkerEntity, AppOpenedMarker> {
  @override
  final Directory baseDirectory;

  AppOpenedMarkerRepository({required this.baseDirectory});

  @override
  AppOpenedMarkerEntity createEntity() {
    return AppOpenedMarkerEntity();
  }

  @override
  AppOpenedMarker createValueObject() {
    return AppOpenedMarker();
  }
}
