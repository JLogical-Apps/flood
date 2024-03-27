import 'package:persistence_core/src/cache/forever_cache_policy.dart';
import 'package:persistence_core/src/cache/timed_cache_policy.dart';

abstract class CachePolicy {
  bool shouldUseCache();

  void onRetrieveSource();

  static CachePolicy timed(Duration cacheDuration) => TimedCachePolicy(cacheDuration: cacheDuration);

  static CachePolicy get forever => ForeverCachePolicy();
}

mixin IsCachePolicy implements CachePolicy {}
