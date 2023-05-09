import 'package:test/test.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('removeWhereTraverse', () {
    final map = {
      'random': 'hi',
      'one': [1],
      'two': [1, 2],
      'three': {
        'one': [1],
        'two': [1, 2],
      },
    };

    final mapped = map.replaceWhereTraversed(
      (key, value) => value is List<int>,
      (key, value) => (value as List<int>).length,
    );

    expect(
      mapped,
      {
        'random': 'hi',
        'one': 1,
        'two': 2,
        'three': {
          'one': 1,
          'two': 2,
        },
      },
    );
  });
}
