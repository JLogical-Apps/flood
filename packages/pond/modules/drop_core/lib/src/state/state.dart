import 'package:drop_core/src/state/stateful.dart';
import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

class State extends Equatable implements Stateful {
  static const idField = '_id';
  static const typeField = '_type';

  final String? id;
  final String? type;
  final Map<String, dynamic> data;

  const State({this.id, this.type, required this.data});

  @override
  State get state => this;

  @override
  List<Object?> get props => [id, type, data];

  bool get isNew => id == null;

  Map<String, dynamic> get fullData => {
        ...data,
        if (id != null) idField: id,
        if (type != null) typeField: type,
      };

  operator [](String fieldName) {
    return fullData[fieldName];
  }

  operator []=(String fieldName, dynamic value) {
    data[fieldName] = value;
  }

  State copyWith({required String? id, required String? type, Map<String, dynamic>? data}) {
    return State(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  State withId(String? id) {
    return copyWith(id: id, type: type);
  }

  State withData(Map<String, dynamic> data) {
    return copyWith(id: id, type: type, data: data);
  }

  static State fromMap(Map<String, dynamic> fullData) {
    fullData = fullData.copy();

    final id = fullData.remove(State.idField)?.toString();
    final type = fullData.remove(State.typeField)?.toString();
    return State(
      id: id,
      type: type,
      data: fullData.map((key, value) => MapEntry(key.toString(), value)),
    );
  }
}
