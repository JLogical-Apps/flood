import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'has_id.dart';

abstract class Entity extends Record implements HasId {
  String? id;

  Entity({this.id});

  static E? fromState<E extends Entity>(State state) {
    return AppContext.global.constructEntity<E>()
      ..id = state.id
      ..state = state;
  }
}
