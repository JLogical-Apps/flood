import 'package:test/test.dart';
import 'package:utils_core/src/traverser/traverser.dart';

void main() {
  test('traverser', () async {
    final traverser = Traverser((x) => x is List ? x : []);

    expect(
      traverser.traverse(
        [
          1,
          2,
          [3, 4]
        ],
      ).toList(),
      [1, 2, 3, 4],
    );
  });
}
