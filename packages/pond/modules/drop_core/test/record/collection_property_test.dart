import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:runtime_type/type.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('list properties', () {
    final context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent());
    final dropContext = context.locate<DropCoreComponent>()
      ..register<ListData>(ListData.new, name: 'ListData')
      ..register<Embedded>(Embedded.new, name: 'Embedded');

    final listData = ListData();
    expect(listData.getState(dropContext).data, {
      'ints': [],
      'strings': [],
      'embeddeds': [],
    });

    listData.intsProperty.set([1, 2, 3]);
    listData.stringsProperty.set(['one', 'two', 'three']);
    listData.embeddedsProperty.set([
      Embedded()..nameProperty.set('John'),
      Embedded()..nameProperty.set('Jack'),
    ]);
    expect(listData.getState(dropContext).data, {
      'ints': [1, 2, 3],
      'strings': ['one', 'two', 'three'],
      'embeddeds': [
        State(
          type: dropContext.getRuntimeType<Embedded>(),
          data: {'name': 'John'},
        ),
        State(
          type: dropContext.getRuntimeType<Embedded>(),
          data: {'name': 'Jack'},
        ),
      ],
    });

    listData.setState(
      dropContext,
      State(data: {
        'ints': [3, 2, 1],
        'strings': ['three', 'two', 'one'],
        'embeddeds': [
          State(
            type: dropContext.getRuntimeType<Embedded>(),
            data: {'name': 'Jack'},
          ),
          State(
            type: dropContext.getRuntimeType<Embedded>(),
            data: {'name': 'John'},
          ),
        ],
      }),
    );
    expect(listData.intsProperty.value, [3, 2, 1]);
    expect(listData.stringsProperty.value, ['three', 'two', 'one']);
    expect(listData.embeddedsProperty.value, [
      Embedded()..nameProperty.set('Jack'),
      Embedded()..nameProperty.set('John'),
    ]);
  });

  test('map properties', () {
    final context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent());
    final dropContext = context.locate<DropCoreComponent>()..register<MapData>(MapData.new, name: 'MapData');

    final mapData = MapData();
    expect(mapData.getState(dropContext).data, {
      'intById': {},
      'stringById': {},
    });

    mapData.intByIdProperty.value = {'one': 1, 'two': 2, 'three': 3};
    mapData.stringByIdProperty.value = {'A': 'a', 'B': 'b', 'C': 'c'};
    expect(mapData.getState(dropContext).data, {
      'intById': {'one': 1, 'two': 2, 'three': 3},
      'stringById': {'A': 'a', 'B': 'b', 'C': 'c'},
    });

    mapData.setState(
        dropContext,
        State(data: {
          'intById': {'three': 3, 'two': 2, 'one': 1},
          'stringById': {'C': 'c', 'B': 'b', 'A': 'a'},
        }));
    expect(mapData.intByIdProperty.value, {'three': 3, 'two': 2, 'one': 1});
    expect(mapData.stringByIdProperty.value, {'C': 'c', 'B': 'b', 'A': 'a'});
  });
}

class ListData extends ValueObject {
  late final intsProperty = field<int>(name: 'ints').list();
  late final stringsProperty = field<String>(name: 'strings').list();
  late final embeddedsProperty = field<Embedded>(name: 'embeddeds').list().embedded();

  @override
  List<ValueObjectBehavior> get behaviors => [intsProperty, stringsProperty, embeddedsProperty];
}

class MapData extends ValueObject {
  late final intByIdProperty = field<String>(name: 'intById').mapTo<int>();
  late final stringByIdProperty = field<String>(name: 'stringById').mapTo<String>();

  @override
  List<ValueObjectBehavior> get behaviors => [intByIdProperty, stringByIdProperty];
}

class Embedded extends ValueObject {
  late final nameProperty = field<String>(name: 'name');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}
