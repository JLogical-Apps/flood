import 'package:persistence_core/src/cache/cache_policy.dart';
import 'package:utils_core/utils_core.dart';

class TimedCachePolicy with IsCachePolicy {
  final Duration cacheDuration;

  DateTime? lastRetrievalTime;

  TimedCachePolicy({required this.cacheDuration});

  @override
  bool shouldUseCache() {
    if (lastRetrievalTime == null) {
      return false;
    }

    return DateTime.now() < lastRetrievalTime!.add(cacheDuration);
  }

  @override
  void onRetrieveSource() {
    lastRetrievalTime = DateTime.now();
  }
}
