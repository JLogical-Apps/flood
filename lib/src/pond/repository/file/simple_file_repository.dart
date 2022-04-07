import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'default_abstract_file_repository.dart';

class SimpleFileRepository<E extends Entity<V>, V extends ValueObject> extends DefaultAbstractFileRepository<E, V> {
  @override
  final String dataPath;

  final List<ValueObjectRegistration> valueObjectRegistrations;
  final List<EntityRegistration> entityRegistrations;
  final Future<void> Function(State state)? stateInitializer;

  SimpleFileRepository({
    required this.dataPath,
    required this.valueObjectRegistrations,
    required this.entityRegistrations,
    this.stateInitializer,
  });

  @override
  Future<void> initializeState(State state) async {
    await stateInitializer?.call(state);
  }
}
