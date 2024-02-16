import 'dart:convert';
import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/deploy_targets/util/apple_api_key_retrieval_method.dart';
import 'package:release/src/metadata_context.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class AppStoreDeployTarget with IsDeployTarget {
  @override
  Future onDeploy(AutomateCommandContext context, ReleaseContext releaseContext, ReleasePlatform platform) {
    throw Exception('Cannot deploy directly to App Store! Deploy to TestFlight and then promote the build.');
  }

  @override
  Future onSyncMetadata(
    AutomateCommandContext context,
    MetadataContext metadataContext,
    ReleasePlatform platform,
  ) async {
    final identifier = await context.getIosIdentifier();

    final apiKeyFile = await createApiKeyFile(
      context,
      apiKeyEncoded: await getApiKeyEncoded(context),
      keyId: await getApiKeyId(context),
      issuerId: await getApiKeyIssuer(context),
    );

    await context.run(
      'fastlane deliver '
      '--app_identifier $identifier '
      '--api_key_path ${apiKeyFile.path} '
      '--screenshots_path ${(metadataContext.screenshotsDirectory / 'apple').path} '
      '--overwrite_screenshots '
      '--skip_binary_upload '
      '--skip_metadata '
      '--skip_app_version_update '
      '--run_precheck_before_submit false',
      interactable: true,
    );
  }

  Future<String> getApiKeyEncoded(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('appStore/apiKeyEncoded', () async {
      final apiKeyMethod = context.select(
        prompt: 'Provide an App Store Connect API Key. '
            'This is used for `fastlane match` to be able to sign your app. '
            'There are two ways for you to provide this API Key:\n'
            '1) Create an API Key with Admin priveleges at https://appstoreconnect.apple.com/access/api, '
            'download the .p8 file, and submit the path to the .p8 file.\n'
            '2) If you already have a base-64 encoded API Key from another project, you can simply input that here.\n'
            'How would you like to import your API Key?',
        options: ApiKeyRetrievalMethod.values,
        stringMapper: (method) => method.displayName,
      );

      return await apiKeyMethod.retrieveEncodedApiKey(context);
    });
  }

  Future<File> createApiKeyFile(
    AutomateCommandContext context, {
    required String keyId,
    required String issuerId,
    required String apiKeyEncoded,
  }) async {
    final file = await context.createTempFile('apiKey.json');

    final decodedKey = base64.decode(apiKeyEncoded);
    final decodedKeyString = utf8.decode(decodedKey);

    await DataSource.static.file(file).mapJson().set({
      'key_id': keyId,
      'issuer_id': issuerId,
      'key': decodedKeyString,
      'in_house': false,
    });

    return file;
  }

  Future<String> getApiKeyId(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('appStore/apiKeyId', () async {
      final apiKeyId =
          context.input('Provide the App Store Connect Key ID. You will find this as the "KEY ID" of the key.');
      if (apiKeyId.isBlank) {
        throw Exception('App Store Conect Key ID not provided!');
      }

      return apiKeyId;
    });
  }

  Future<String> getApiKeyIssuer(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('appStore/apiKeyIssuer', () async {
      final apiKeyIssuer = context.input('Provide the Issuer ID. You will find this as the "Issuer ID"');
      if (apiKeyIssuer.isBlank) {
        throw Exception('App Store Conect Key Issuer not provided!');
      }

      return apiKeyIssuer;
    });
  }
}
