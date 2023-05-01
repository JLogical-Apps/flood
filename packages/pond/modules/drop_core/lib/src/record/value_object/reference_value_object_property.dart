import 'package:drop_core/src/context/drop_core_context.dart';
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
  void fromState(State state) {
    value = state[name] as String?;
  }

  @override
  State modifyState(State state) {
    if (value == null) {
      return state;
    }

    return state.withData(state.data.copy()..set(name, value));
  }

  @override
  Future<E?> load(DropCoreContext context) async {
    return await value?.mapIfNonNullAsync((value) => Query.getById<E>(value).get(context));
  }

  @override
  ReferenceValueObjectProperty<E> copy() {
    return ReferenceValueObjectProperty<E>(name: name, value: value);
  }
}
