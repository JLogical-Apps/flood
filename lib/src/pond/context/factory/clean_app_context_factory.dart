import 'package:jlogical_utils/src/pond/context/metadata/context_metadata.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';

import '../../modules/core_module.dart';
import '../app_context.dart';

Future<void> buildBaseAppContext(AppContext context) async {
  context.contextMetadata = ContextMetadata(buildType: BuildType.debug, buildTarget: BuildTarget.standalone);
  context.register(CoreModule());
}
