import 'package:persistence_core/persistence_core.dart';
import 'package:test/test.dart';

void main() {
  test('memory data source get and set', () async {
    var memoryDataSource = DataSource.static.memory<int>();
    expect(await memoryDataSource.getOrNull(), null);

    memoryDataSource = DataSource.static.memory<int>(initialData: 0);
    expect(await memoryDataSource.getOrNull(), 0);

    await memoryDataSource.set(3);
    expect(await memoryDataSource.getOrNull(), 3);

    await memoryDataSource.delete();
    expect(await memoryDataSource.getOrNull(), null);
  });

  test('mapped memory data source get and set', () async {
    final memoryDataSource = DataSource.static.memory<int>();
    final negativeDataSource = memoryDataSource.map<int>(
      getMapper: (value) => -value,
      setMapper: (value) => -value,
    );

    expect(await negativeDataSource.getOrNull(), null);

    await negativeDataSource.set(-1);
    expect(await memoryDataSource.getOrNull(), 1);
    expect(await negativeDataSource.getOrNull(), -1);

    await negativeDataSource.delete();
    expect(await memoryDataSource.getOrNull(), null);
    expect(await negativeDataSource.getOrNull(), null);

    await memoryDataSource.set(3);
    expect(await memoryDataSource.getOrNull(), 3);
    expect(await negativeDataSource.getOrNull(), -3);

    await memoryDataSource.delete();
    expect(await memoryDataSource.getOrNull(), null);
    expect(await negativeDataSource.getOrNull(), null);
  });

  test('memory data source getX', () async {
    final memoryDataSource = DataSource.static.memory<int>();
    expect(memoryDataSource.getXOrNull(), null);

    await memoryDataSource.set(1);
    final dataX = memoryDataSource.getXOrNull();

    expectLater(dataX, emitsInOrder([1, 2, 3, emitsDone]));

    await memoryDataSource.set(2);
    await memoryDataSource.set(3);
    await memoryDataSource.delete();
  });

  test('mapped data source getX', () async {
    final memoryDataSource = DataSource.static.memory<int>();
    final negativeDataSource = memoryDataSource.map<int>(
      getMapper: (value) => -value,
      setMapper: (value) => -value,
    );
    expect(negativeDataSource.getXOrNull(), null);

    await negativeDataSource.set(-1);
    final dataX = memoryDataSource.getXOrNull();

    expectLater(dataX, emitsInOrder([1, 2, 3, emitsDone]));

    await memoryDataSource.set(2);
    await negativeDataSource.set(-3);
    await memoryDataSource.delete();
  });
}
