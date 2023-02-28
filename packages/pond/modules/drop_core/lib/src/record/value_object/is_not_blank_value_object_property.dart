import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class IsNotBlankValueObjectProperty<L> with IsValueObjectProperty<String, String, L> {
  final ValueObjectProperty<String?, String?, L> property;

  IsNotBlankValueObjectProperty({required this.property});

  @override
  State modifyState(State state) {
    if (property.value == null || property.value!.isBlank) {
      throw Exception('Cannot be blank! [$property]');
    }

    return property.modifyState(state);
  }

  @override
  State modifyStateUnsafe(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);

    if (property.value == null || property.value!.isBlank) {
      throw Exception('Cannot be blank! [$property]');
    }
  }

  @override
  String get value => property.value == null || property.value!.isBlank
      ? (throw Exception('Cannot be blank! [$property]'))
      : property.value!;

  @override
  void set(String value) => property.set(value);

  @override
  Future<L> load(DropCoreContext context) => property.load(context);
}
