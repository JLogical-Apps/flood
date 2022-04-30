import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/modules/analytics/analytics_service.dart';

abstract class AnalyticsEvent {
  String get name;

  Map<String, dynamic> get parameters => {};

  Future<void> log() async {
    await locateOrNull<AnalyticsService>()?.logEvent(this);
  }
}
