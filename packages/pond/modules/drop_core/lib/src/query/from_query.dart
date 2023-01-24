import 'package:drop_core/src/query/query.dart';

class FromQuery extends Query {
  final Type entityType;

  FromQuery({required this.entityType}) : super(parent: null);

  @override
  String toString() {
    return 'from $entityType';
  }
}
