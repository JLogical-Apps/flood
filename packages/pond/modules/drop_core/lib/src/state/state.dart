import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/stateful.dart';
import 'package:equatable/equatable.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class State extends Equatable implements Stateful {
  static const idField = '_id';
  static const typeField = '_type';

  final String? id;
  final bool isNew;
  final RuntimeType? type;
  final Map<String, dynamic> data;

  const State({this.id, bool? isNew, this.type, required this.data}) : isNew = isNew ?? id == null;

  @override
  State getState(DropCoreContext context) => this;

  @override
  State getStateUnsafe(DropCoreContext context) => this;

  @override
  List<Object?> get props => [id, type, data];

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

  State copyWith({required String? id, bool? isNew, required RuntimeType? type, Map<String, dynamic>? data}) {
    return State(
      id: id ?? this.id,
      isNew: isNew ?? this.isNew,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  State withId(String? id) {
    return copyWith(id: id, type: type);
  }

  State withIsNew(bool isNew) {
    return copyWith(id: id, type: type, isNew: isNew);
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
    required TypeContext typeContext,
  }) {
    fullData = fullData.copy();

    final id = fullData.remove(State.idField)?.toString();

    final typeValue = fullData.remove(State.typeField);
    final type = typeValue is RuntimeType
        ? typeValue
        : typeValue is String
            ? typeContext.getByNameOrNull(typeValue)
            : null;

    return State(
      id: id,
      type: type,
      data: fullData.cast<String, dynamic>(),
    );
  }

  @override
  String toString() {
    return 'State($id, $type, $data)';
  }
}
