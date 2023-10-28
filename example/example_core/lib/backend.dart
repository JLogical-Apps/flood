import 'dart:async';
import 'dart:io';

import 'package:example_core/pond.dart';
import 'package:jlogical_utils_cli/jlogical_utils_cli.dart';

Future<dynamic> main(final context) async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'example'),
    loggerService: (_) => LoggerService.static.appwrite(context),
    taskRunner: (_) => TaskRunner.static.local,
    repositoryImplementations: (_) => [
      AppwriteCloudRepositoryImplementation(),
    ],
    additionalCoreComponents: (corePondContext) async => [
      AppwriteCoreComponent(
        config: AppwriteConfig(
          projectId: await corePondContext.environmentCoreComponent.get(AppwriteConsts.projectIdFunctionEnv),
          endpoint: await corePondContext.environmentCoreComponent.get(AppwriteConsts.endpointFunctionEnv),
          selfSigned: await corePondContext.environmentCoreComponent.get(AppwriteConsts.selfSignedFunctionEnv),
        ),
      ),
    ],
  );
  return await AppwriteBackend.handle(
    corePondContext: corePondContext,
    context: context,
  );
}
