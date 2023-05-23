import 'dart:async';

import 'package:actions_core/actions_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/repository/repository_list_wrapper.dart';
import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

class DropCoreComponent extends CorePondComponent with IsDropCoreContext, IsRepositoryListWrapper {
  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<TypeCoreComponent>(),
        CorePondComponentBehavior(onLoad: (context, component) {
          context.locate<TypeCoreComponent>().registerAbstract<ValueObject>(name: 'ValueObject');
        })
      ];

  @override
  TypeContext get typeContext => context.locate<TypeCoreComponent>();

  @override
  List<Repository> get repositories =>
      context.components.whereType<Repository>().where((repository) => repository != this).toList();

  @override
  Future<State> onUpdate(State state) {
    return context.run(updateAction, state);
  }

  @override
  Future<State> onDelete(State state) {
    return context.run(deleteAction, state);
  }

  late final updateAction = Action(
    name: 'Update',
    runner: (State state) => super.onUpdate(state),
  );

  late final deleteAction = Action(
    name: 'Delete',
    runner: (State state) => super.onDelete(state),
  );
}
