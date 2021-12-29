import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';

import 'entities/budget.dart';
import 'entities/color.dart';
import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';
import 'entities/lucky_numbers.dart';
import 'entities/palette.dart';
import 'entities/palette_stats.dart';
import 'entities/transaction.dart';
import 'entities/user.dart';
import 'entities/user_avatar.dart';
import 'entities/user_entity.dart';

void main() {
  test('state inflation on simple ValueObject.', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Envelope, Envelope?>(() => Envelope()),
        ],
      ),
    );

    final state = State(
      type: '$Envelope',
      values: {
        'name': 'Tithe',
        'amount': 24 * 100,
      },
    );

    final envelope = ValueObject.fromState<Envelope>(state);

    expect(envelope.state, state);
    expect(envelope.nameProperty.value, 'Tithe');
    expect(envelope.amountProperty.value, 24 * 100);
  });

  test('state inflation of record that has a list', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<LuckyNumbers, LuckyNumbers?>(() => LuckyNumbers()),
        ],
      ),
    );

    const luckyNumbers = [4, 8, 15, 16, 23, 42];

    final state = State(
      type: '$LuckyNumbers',
      values: {
        'luckyNumbers': luckyNumbers,
      },
    );

    final luckyNumbersEntity = ValueObject.fromState<LuckyNumbers>(state);

    expect(luckyNumbersEntity.state, state);
    expect(luckyNumbersEntity.luckyNumbersProperty.value, luckyNumbers);
  });

  test('state inflation of record that has a map.', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Color, Color?>(() => Color()),
        ],
      ),
    );

    const rgb = {'r': 0, 'g': 152, 'b': 19};

    final state = State(
      type: '$Color',
      values: {
        'rgb': rgb,
      },
    );

    final color = ValueObject.fromState<Color>(state);

    expect(color.state, state);
    expect(color.rgbProperty.value, rgb);
  });

  test('state inflation of record that has a value object.', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Color, Color?>(() => Color()),
          ValueObjectRegistration<UserAvatar, UserAvatar?>(() => UserAvatar()),
        ],
      ),
    );

    const rgb = {'r': 0, 'g': 152, 'b': 19};

    final state = State(
      type: '$UserAvatar',
      values: {
        'color': {
          '_type': 'Color',
          'rgb': rgb,
        },
      },
    );

    final userAvatar = ValueObject.fromState<UserAvatar>(state);
    final color = Color()..rgbProperty.value = rgb;

    expect(userAvatar.state, state);
    expect(userAvatar.colorProperty.value, color);
  });

  test('state inflation of record that has a list of value objects.', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Palette, Palette?>(() => Palette()),
          ValueObjectRegistration<Color, Color?>(() => Color()),
        ],
      ),
    );

    const white = {'r': 255, 'g': 255, 'b': 255};
    const black = {'r': 0, 'g': 0, 'b': 0};

    final state = State(
      type: '$Palette',
      values: {
        'colors': [
          {
            '_type': 'Color',
            'rgb': white,
          },
          {
            '_type': 'Color',
            'rgb': black,
          },
        ],
      },
    );

    final palette = ValueObject.fromState<Palette>(state);
    final whiteColor = Color()..rgbProperty.value = white;
    final blackColor = Color()..rgbProperty.value = black;

    expect(palette.state, state);
    expect(palette.colorsProperty.value, [whiteColor, blackColor]);
  });

  test('state inflation of record that has a map with value objects.', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Color, Color?>(() => Color()),
          ValueObjectRegistration<PaletteStats, PaletteStats?>(() => PaletteStats()),
        ],
      ),
    );

    const white = {'r': 255, 'g': 255, 'b': 255};
    const black = {'r': 0, 'g': 0, 'b': 0};

    final state = State(
      type: '$PaletteStats',
      values: {
        'colorUses': {
          {
            '_type': 'Color',
            'rgb': white,
          }: 4,
          {
            '_type': 'Color',
            'rgb': black,
          }: 2,
        },
      },
    );

    final paletteStats = ValueObject.fromState<PaletteStats>(state);
    final whiteColor = Color()..rgbProperty.value = white;
    final blackColor = Color()..rgbProperty.value = black;

    expect(paletteStats.state, state);
    expect(paletteStats.colorUses.value, {whiteColor: 4, blackColor: 2});
  });

  test('state inflation of record that has a reference to an entity.', () {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<Envelope, Envelope?>(() => Envelope()),
          ValueObjectRegistration<EnvelopeTransaction, EnvelopeTransaction?>(() => EnvelopeTransaction()),
        ],
      ),
    );

    final state = State(
      type: '$EnvelopeTransaction',
      values: {
        'envelope': 'envelope1',
      },
    );

    final transaction = ValueObject.fromState<EnvelopeTransaction>(state);
    expect(transaction.state, state);

    final envelope = EnvelopeEntity(initialEnvelope: Envelope())..id = 'envelope2';

    transaction.envelopeProperty.reference = envelope;
    final newState = State(
      type: '$EnvelopeTransaction',
      values: {
        'envelope': 'envelope2',
      },
    );
    expect(transaction.state, newState);
  });

  test('required validation working', () {
    expect(() => Color()..validate(), throwsA(isA<ValidationException>()));
  });

  test('fallback working', () async {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        valueObjectRegistrations: [
          ValueObjectRegistration<User, User?>(() => User()),
        ],
        entityRegistrations: [
          EntityRegistration<UserEntity, User>((initialUser) => UserEntity(initialUser: initialUser)),
        ],
        database: EntityDatabase(repositories: [
          LocalUserRepository(),
        ]),
      ),
    );

    final userEntity = UserEntity(initialUser: User()..nameProperty.value = 'Jake');
    await userEntity.create();

    final budget = Budget()..ownerProperty.reference = userEntity;

    expect(budget.nameProperty.value, userEntity.value.nameProperty.value);
  });
}

class LocalUserRepository extends EntityRepository
    with
        WithMonoEntityRepository<UserEntity>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithDomainRegistrationsProvider<User, UserEntity>,
        WithTransactionsAndCacheEntityRepository
    implements RegistrationsProvider {
  @override
  UserEntity createEntity(User initialValue) {
    throw UserEntity(initialUser: initialValue);
  }

  @override
  User createValueObject() {
    return User();
  }
}
