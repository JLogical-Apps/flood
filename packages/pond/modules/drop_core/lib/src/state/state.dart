import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:equatable/equatable.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class State extends Equatable implements Stateful {
  static const idField = '_id';
  static const typeField = '_type';

  final String? id;
  final RuntimeType? type;
  final Map<String, dynamic> data;

  const State({this.id, this.type, required this.data});

  @override
  State getState(DropCoreContext context) => this;

  @override
  State getStateUnsafe(DropCoreContext context) => this;

  @override
  List<Object?> get props => [id, type, data];

  bool get isNew => id == null;

  Map<String, dynamic> get fullData => {
        if (id != null) idField: id,
        if (type != null) typeField: type,
        ...data,
      };

  operator [](String fieldName) {
    return fullData[fieldName];
  }

  operator []=(String fieldName, dynamic value) {
    data[fieldName] = value;
  }

  State copyWith({required String? id, required RuntimeType? type, Map<String, dynamic>? data}) {
    return State(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  State withId(String? id) {
    return copyWith(id: id, type: type);
  }

  State withType(RuntimeType type) {
    return copyWith(id: id, type: type);
  }

  State withData(Map<String, dynamic> data) {
    return copyWith(id: id, type: type, data: data);
  }

  State mergeWith(State state) {
    return withData({...data, ...state.data});
  }

  static State fromMap(
    Map<String, dynamic> fullData, {
    required RuntimeType Function(String typeName) runtimeTypeGetter,
  }) {
    fullData = fullData.copy();

    final id = fullData.remove(State.idField)?.toString();

    final typeValue = fullData.remove(State.typeField);
    final type = typeValue is RuntimeType
        ? typeValue
        : typeValue is String
            ? runtimeTypeGetter(typeValue)
            : null;

    return State(
      id: id,
      type: type,
      data: fullData.cast<String, dynamic>(),
    );
  }
}
