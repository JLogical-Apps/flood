import 'package:drop_core/src/repository/repository.dart';

class BlankRepository with IsRepositoryWrapper {
  @override
  final Repository repository;

  BlankRepository({required this.repository});
}
