import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:persistence_core/persistence_core.dart';

extension DataSourceExtensions on DataSource<State> {
  DataSource<E> mapEntity<E extends Entity>(DropCoreContext context) {
    return map(
      getMapper: (state) => context.constructEntityFromState(state),
      setMapper: (entity) => entity.getState(context),
    );
  }
}
