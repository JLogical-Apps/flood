import 'package:jlogical_utils/src/pond/context/metadata/context_metadata.dart';

import '../../modules/core_module.dart';
import '../app_context.dart';

Future<void> buildBaseAppContext(AppContext context) async {
  context.contextMetadata = ContextMetadata(buildType: BuildType.debug);
  context.register(CoreModule());
}
