import '../../record/entity.dart';
import '../../state/state.dart';

class EntityInflater {
  final Future<void> Function(State state)? stateInitializer;
  final Future<void> Function(Entity entity)? entityInflater;

  EntityInflater({this.stateInitializer, this.entityInflater});

  Future<void> initializeState(State state) async {
    await stateInitializer?.call(state);
  }

  Future<void> inflateEntity(Entity entity) async {
    await entityInflater?.call(entity);
  }
}
