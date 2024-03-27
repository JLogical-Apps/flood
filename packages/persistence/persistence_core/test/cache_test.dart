import 'package:persistence_core/persistence_core.dart';
import 'package:test/test.dart';

void main() {
  test('cache', () async {
    var cacheLoadCount = 0;
    final cache = Cache(
      () {
        cacheLoadCount++;
        return null;
      },
      cachePolicy: CachePolicy.forever,
    );

    await cache.get();
    expect(cacheLoadCount, 1);

    await cache.get();
    expect(cacheLoadCount, 1);
  });
}
