import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/property/with_properties_state.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/state/stateful.dart';

abstract class Entity with WithPropertiesState implements Stateful {
  String? id;

  Entity({this.id});

  State get state => generatePropertiesState(id);

  static E? fromState<E extends Entity>(State state) {
    return AppContext.global.constructEntity<E>()
      ?..id = state.id
      ..inflateProperties(state);
  }
}
