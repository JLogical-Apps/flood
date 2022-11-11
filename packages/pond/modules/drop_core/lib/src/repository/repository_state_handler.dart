import 'package:drop_core/src/state/state.dart';

abstract class RepositoryStateHandler {
  Future<void> update(State state);

  Future<void> delete(State state);
}
