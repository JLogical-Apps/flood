import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/value_object_type_state_serializer.dart';

import 'entities/budget_transaction.dart';
import 'entities/budget_transaction_entity.dart';
import 'entities/color.dart';
import 'entities/envelope_transaction.dart';
import 'entities/envelope_transaction_entity.dart';
import 'entities/transfer_transaction.dart';
import 'entities/transfer_transaction_entity.dart';

void main() {
  test('only nullabe serializers deserialize non-null values', () {
    final stringSerializer = StringTypeStateSerializer();
    expect(() => stringSerializer.deserialize(null), throwsA(isA<Error>()));

    final nullableSerializer = NullableTypeStateSerializer(stringSerializer);
    expect(nullableSerializer.deserialize(null), null);
  });

  test('serializing strings', () {
    final stringSerializer = StringTypeStateSerializer();
    expect(stringSerializer.deserialize('hello world'), 'hello world');
    expect(stringSerializer.deserialize(5), '5');
    expect(stringSerializer.deserialize(3.0), '3');
    expect(stringSerializer.deserialize(3.16), '3.16');
    expect(stringSerializer.deserialize(true), 'true');
  });

  test('serializing ints', () {
    final roundingIntSerializer = IntTypeStateSerializer(intConverterPolicy: IntConverterPolicy.round());
    expect(roundingIntSerializer.deserialize(5), 5);
    expect(roundingIntSerializer.deserialize(3.5), 4);
    expect(roundingIntSerializer.deserialize(1.2), 1);
    expect(roundingIntSerializer.deserialize(4.9), 5);
    expect(roundingIntSerializer.deserialize('-2.5'), -3);
    expect(roundingIntSerializer.deserialize('-10'), -10);
    expect(() => roundingIntSerializer.deserialize('hello world'), throwsA(isA<FormatException>()));

    final flooringIntSerializer = IntTypeStateSerializer(intConverterPolicy: IntConverterPolicy.floor());
    expect(flooringIntSerializer.deserialize(5), 5);
    expect(flooringIntSerializer.deserialize(3.5), 3);
    expect(flooringIntSerializer.deserialize(1.2), 1);
    expect(flooringIntSerializer.deserialize(4.9), 4);
    expect(flooringIntSerializer.deserialize('-2.5'), -3);
    expect(flooringIntSerializer.deserialize('-10'), -10);

    final truncatingIntSerializer = IntTypeStateSerializer(intConverterPolicy: IntConverterPolicy.truncate());
    expect(truncatingIntSerializer.deserialize(5), 5);
    expect(truncatingIntSerializer.deserialize(3.5), 3);
    expect(truncatingIntSerializer.deserialize(1.2), 1);
    expect(truncatingIntSerializer.deserialize(4.9), 4);
    expect(truncatingIntSerializer.deserialize('-2.5'), -2);
    expect(truncatingIntSerializer.deserialize('-10'), -10);
  });

  test('serializing doubles', () {
    final doubleSerializer = DoubleTypeStateSerializer();
    expect(doubleSerializer.deserialize(5), 5.0);
    expect(doubleSerializer.deserialize(3.5), 3.5);
    expect(doubleSerializer.deserialize('-2.5'), -2.5);
    expect(doubleSerializer.deserialize('-10'), -10.0);
    expect(() => doubleSerializer.deserialize('hello world'), throwsA(isA<FormatException>()));
  });

  test('serializing bools', () {
    final boolSerializer = BoolTypeStateSerializer();
    expect(boolSerializer.deserialize(false), false);
    expect(boolSerializer.deserialize('true'), true);
  });

  test('serializing value objects', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Color, Color?>(() => Color()),
        ],
      ),
    );

    final white = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};
    final colorSerializer = ValueObjectTypeStateSerializer();

    expect(colorSerializer.serialize(white), {
      '_type': '$Color',
      'rgb': {'r': 255, 'g': 255, 'b': 255},
    });

    expect(
      colorSerializer.deserialize({
        '_type': '$Color',
        'rgb': {'r': 255, 'g': 255, 'b': 255}
      }),
      white,
    );

    expect(() => colorSerializer.deserialize(null), throwsA(isA<Exception>()));

    final nullableColorSerializer = NullableTypeStateSerializer(colorSerializer);
    expect(nullableColorSerializer.deserialize(null), null);
  });

  test('serializing lists', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Color, Color?>(() => Color()),
        ],
      ),
    );

    final nonNullListSerializer = ListTypeStateSerializer<int>();
    expect(nonNullListSerializer.deserialize(['2', 4]), [2, 4]);
    expect(nonNullListSerializer.deserialize([]), []);
    expect(() => nonNullListSerializer.deserialize(['hello world']), throwsA(isA<FormatException>()));
    expect(() => nonNullListSerializer.deserialize([null, 4]), throwsA(isA<Error>()));

    final nullableListSerializer = ListTypeStateSerializer<int?>();
    expect(nullableListSerializer.deserialize([null, 4]), [null, 4]);

    final white = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};
    final black = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};
    final colorSerializer = ListTypeStateSerializer<Color>();
    expect(
      colorSerializer.deserialize([
        {
          '_type': '$Color',
          'rgb': {'r': 255, 'g': 255, 'b': 255}
        },
        {
          '_type': '$Color',
          'rgb': {'r': 0, 'g': 0, 'b': 0}
        },
      ]),
      [white, black],
    );

    expect(() => colorSerializer.deserialize([null]), throwsA(isA<Exception>()));

    final nullableColorSerializer = ListTypeStateSerializer<Color?>();
    expect(nullableColorSerializer.deserialize([null]), [null]);
  });

  test('serializing maps', () {
    final nonNullListSerializer = MapTypeStateSerializer<int, String>();
    expect(nonNullListSerializer.deserialize({1: 'one', '2': 'two'}), {1: 'one', 2: 'two'});
    expect(nonNullListSerializer.deserialize({}), {});
    expect(() => nonNullListSerializer.deserialize(['hello world']), throwsA(isA<Exception>()));
    expect(() => nonNullListSerializer.deserialize({'hello world': 1}), throwsA(isA<FormatException>()));
    expect(() => nonNullListSerializer.deserialize({0: null}), throwsA(isA<Error>()));

    final nullableListSerializer = MapTypeStateSerializer<int, String?>();
    expect(nullableListSerializer.deserialize({0: null}), {0: null});

    final white = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};
    final black = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};
    final colorSerializer = ListTypeStateSerializer<Color>();
    expect(
      colorSerializer.deserialize([
        {
          '_type': '$Color',
          'rgb': {'r': 255, 'g': 255, 'b': 255}
        },
        {
          '_type': '$Color',
          'rgb': {'r': 0, 'g': 0, 'b': 0}
        },
      ]),
      [white, black],
    );
  });

  test('serializing & deserializing abstract class', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<BudgetTransaction, BudgetTransaction?>.abstract(),
          ValueObjectRegistration<EnvelopeTransaction, EnvelopeTransaction?>(
            () => EnvelopeTransaction(),
            parents: {BudgetTransaction},
          ),
          ValueObjectRegistration<TransferTransaction, TransferTransaction?>(
            () => TransferTransaction(),
            parents: {BudgetTransaction},
          ),
          ValueObjectRegistration<BudgetTransactionWrapper, BudgetTransactionWrapper?>(BudgetTransactionWrapper.new),
        ],
        entityRegistrations: [
          EntityRegistration<BudgetTransactionEntity, BudgetTransaction>.abstract(),
          EntityRegistration<EnvelopeTransactionEntity, EnvelopeTransaction>(
              (initialValue) => EnvelopeTransactionEntity(initialValue)),
          EntityRegistration<TransferTransactionEntity, TransferTransaction>(
            (initialValue) => TransferTransactionEntity(initialValue),
          ),
        ],
      ),
    );

    final envelopeTransaction = EnvelopeTransaction()
      ..nameProperty.value = 'test'
      ..amountProperty.value = 10 * 100;
    final budgetTransactionWrapper = BudgetTransactionWrapper()..budgetTransactionProperty.value = envelopeTransaction;

    final valueObjectSerializer = ValueObjectTypeStateSerializer();

    var serialized = valueObjectSerializer.serialize(budgetTransactionWrapper);

    expect(
      serialized,
      {
        '_type': '$BudgetTransactionWrapper',
        'transaction': {
          '_type': '$EnvelopeTransaction',
          'name': 'test',
          'amount': 10 * 100,
        },
      },
    );

    var deserializedWrapper = valueObjectSerializer.deserialize(serialized) as BudgetTransactionWrapper;
    expect(deserializedWrapper.budgetTransactionProperty.value, isA<EnvelopeTransaction>());

    budgetTransactionWrapper.budgetTransactionProperty.value = TransferTransaction()..amountProperty.value = 5 * 100;

    serialized = valueObjectSerializer.serialize(budgetTransactionWrapper);

    expect(
      serialized,
      {
        '_type': '$BudgetTransactionWrapper',
        'transaction': {
          '_type': '$TransferTransaction',
          'amount': 5 * 100,
        }
      },
    );

    deserializedWrapper = valueObjectSerializer.deserialize(serialized) as BudgetTransactionWrapper;
    expect(deserializedWrapper.budgetTransactionProperty.value, isA<TransferTransaction>());
  });
}

class BudgetTransactionWrapper extends ValueObject {
  late final budgetTransactionProperty = FieldProperty<BudgetTransaction>(name: 'transaction');

  @override
  List<Property> get properties => [budgetTransactionProperty];
}

class BudgetTransactionWrapperEntity extends Entity {
  BudgetTransactionWrapperEntity(BudgetTransactionWrapper initialValue) : super(initialValue: initialValue);
}
