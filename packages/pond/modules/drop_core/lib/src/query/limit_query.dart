import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class LimitQuery<E extends Entity> extends Query<E> {
  final int limit;

  LimitQuery({required Query parent, required this.limit}) : super(parent: parent);

  @override
  String prettyPrint(DropCoreContext context) {
    return '${parent!.prettyPrint(context)} | limit $limit';
  }

  @override
  List<Object?> get props => [parent, limit];
}
