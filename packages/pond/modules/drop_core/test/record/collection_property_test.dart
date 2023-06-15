import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('list properties', () {
    final context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(CoreDropComponent());
    final dropContext = context.locate<CoreDropComponent>()..register<ListData>(ListData.new, name: 'ListData');

    final listData = ListData();
    expect(listData.getState(dropContext).data, {});

    listData.intsProperty.value = [1, 2, 3];
    listData.stringsProperty.value = ['one', 'two', 'three'];
    expect(listData.getState(dropContext).data, {
      'ints': [1, 2, 3],
      'strings': ['one', 'two', 'three'],
    });

    listData.setState(
      context.coreDropComponent,
      State(data: {
        'ints': [3, 2, 1],
        'strings': ['three', 'two', 'one'],
      }),
    );
    expect(listData.intsProperty.value, [3, 2, 1]);
    expect(listData.stringsProperty.value, ['three', 'two', 'one']);
  });

  test('map properties', () {
    final context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(CoreDropComponent());
    final dropContext = context.locate<CoreDropComponent>()..register<MapData>(MapData.new, name: 'MapData');

    final mapData = MapData();
    expect(mapData.getState(dropContext).data, {});

    mapData.intByIdProperty.value = {'one': 1, 'two': 2, 'three': 3};
    mapData.stringByIdProperty.value = {'A': 'a', 'B': 'b', 'C': 'c'};
    expect(mapData.getState(dropContext).data, {
      'intById': {'one': 1, 'two': 2, 'three': 3},
      'stringById': {'A': 'a', 'B': 'b', 'C': 'c'},
    });

    mapData.setState(
      context.coreDropComponent,
      State(data: {
        'intById': {'three': 3, 'two': 2, 'one': 1},
        'stringById': {'C': 'c', 'B': 'b', 'A': 'a'},
      }),
    );
    expect(mapData.intByIdProperty.value, {'three': 3, 'two': 2, 'one': 1});
    expect(mapData.stringByIdProperty.value, {'C': 'c', 'B': 'b', 'A': 'a'});
  });
}

class ListData extends ValueObject {
  late final intsProperty = field<List<int>>(name: 'ints');
  late final stringsProperty = field<List<String>>(name: 'strings');

  @override
  List<ValueObjectBehavior> get behaviors => [intsProperty, stringsProperty];
}

class MapData extends ValueObject {
  late final intByIdProperty = field<Map<String, int>>(name: 'intById');
  late final stringByIdProperty = field<Map<String, String>>(name: 'stringById');

  @override
  List<ValueObjectBehavior> get behaviors => [intByIdProperty, stringByIdProperty];
}
