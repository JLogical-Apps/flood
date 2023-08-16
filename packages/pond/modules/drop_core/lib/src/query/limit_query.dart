import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class LimitQuery<E extends Entity> extends Query<E> {
  final int limit;

  LimitQuery({required Query parent, required this.limit}) : super(parent: parent);

  @override
  String toString() {
    return '$parent | limit $limit';
  }

  @override
  List<Object?> get props => [limit];
}
