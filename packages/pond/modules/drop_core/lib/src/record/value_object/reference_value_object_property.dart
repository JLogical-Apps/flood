import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class ReferenceValueObjectProperty<E extends Entity>
    with IsValueObjectProperty<String?, String?, E?, ReferenceValueObjectProperty<E>> {
  @override
  final String name;

  @override
  String? value;

  ReferenceValueObjectProperty({required this.name, this.value});

  @override
  set(String? value) => this.value = value;

  @override
  void fromState(CoreDropContext context, State state) {
    value = state[name] as String?;
  }

  @override
  State modifyState(CoreDropContext context, State state) {
    if (value == null) {
      return state;
    }

    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  Future<E?> load(CoreDropContext context) async {
    return await value?.mapIfNonNullAsync((value) => Query.getByIdOrNull<E>(value).get(context));
  }

  @override
  ReferenceValueObjectProperty<E> copy() {
    return ReferenceValueObjectProperty<E>(name: name, value: value);
  }

  @override
  List<Object?> get props => [name, value];
}
