import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class OrderByQuery<E extends Entity> extends Query<E> {
  final String stateField;
  final OrderByType type;

  OrderByQuery({required Query parent, required this.stateField, required this.type}) : super(parent: parent);

  @override
  String toString() {
    return '$parent | order $stateField $type';
  }

  @override
  List<Object?> get props => [stateField, type];
}

enum OrderByType {
  descending,
  ascending,
}
