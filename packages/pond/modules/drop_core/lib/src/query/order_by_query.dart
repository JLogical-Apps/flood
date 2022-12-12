import 'package:drop_core/src/query/query.dart';

class OrderByQuery extends Query {
  final String stateField;
  final OrderByType type;

  OrderByQuery({required Query parent, required this.stateField, required this.type}) : super(parent: parent);
}

enum OrderByType {
  descending,
  ascending,
}
