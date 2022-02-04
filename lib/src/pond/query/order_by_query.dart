import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class OrderByQuery<R extends Record> extends Query<R> {
  final String fieldName;
  final OrderByType orderByType;

  OrderByQuery({required Query parent, required this.fieldName, this.orderByType: OrderByType.ascending})
      : super(parent: parent);

  List<Object?> get props => super.props + [fieldName, orderByType];
}

enum OrderByType {
  ascending,
  descending,
}
