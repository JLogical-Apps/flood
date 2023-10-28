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
    additionalCoreComponents: (corePondContext) => [
      AppwriteCoreComponent(config: corePondContext.environmental((type) {
        if (type == EnvironmentType.static.qa) {
          return AppwriteConfig.localhost(projectId: '651b48116fc13fcb79be');
        } else if (type == EnvironmentType.static.staging) {
          return AppwriteConfig.cloud(projectId: '6409e66ed830e72e8f8d');
        }

        throw Exception('Cannot find Appwrite Config for environment [$type]');
      })),
    ],
  );
  return await AppwriteBackend.handle(
    corePondContext: corePondContext,
    context: context,
  );
}
