import 'package:persistence_core/src/cache/cache_policy.dart';

class ForeverCachePolicy with IsCachePolicy {
  bool hasRetrievedSource = false;

  @override
  bool shouldUseCache() {
    return hasRetrievedSource;
  }

  @override
  void onRetrieveSource() {
    hasRetrievedSource = true;
  }
}
