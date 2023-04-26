import 'package:test/test.dart';
import 'package:utils_core/src/traverser/export.dart';
import 'package:utils_core/utils_core.dart';

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

  test('modifier traverser', () async {
    final traverser = Traverser.fromModifiers([ListModifier()]);

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

class ListModifier with IsModifier implements TraverserModifier {
  @override
  List getNodes(input) {
    return input as List;
  }

  @override
  bool shouldModify(input) {
    return input is List;
  }
}
