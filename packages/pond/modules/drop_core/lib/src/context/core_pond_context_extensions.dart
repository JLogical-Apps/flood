import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension CorePondContextDropExtensions on CorePondContext {
  CoreDropComponent get coreDropComponent => locate<CoreDropComponent>();
}
