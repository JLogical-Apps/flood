import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class WithoutCacheQuery<R extends Record> extends Query<R> {
  WithoutCacheQuery({required Query parent}) : super(parent: parent);

  @override
  List<Object?> get props => parent!.props;

  List<Object?> get queryProps => parent!.queryProps;

  @override
  String toString() {
    return parent.toString();
  }
}
