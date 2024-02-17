import 'dart:convert';
import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';

class AndroidReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'android';

  @override
  Future onBuild(AutomateCommandContext context, ReleaseContext releaseContext) async {
    final keystoreFile = await getKeystoreFile(
      context,
      encodedKeystore: await getEncodedKeystore(context),
    );

    final keyPropertiesFile = await getKeyPropertiesFile(
      context,
      alias: await getKeystoreAlias(context),
      password: await getKeystorePassword(context),
      keystoreFile: keystoreFile,
    );

    await context.appProject
        .run('flutter build ${releaseContext.isDebug ? 'apk --debug' : 'appbundle'}');

    await DataSource.static.file(keystoreFile).delete();
    await DataSource.static.file(keyPropertiesFile).delete();
  }

  Future<File> getKeystoreFile(AutomateCommandContext context, {required String encodedKeystore}) async {
    final keystoreFile = context.appDirectory / 'android' - 'upload-keystore.jks';
    final decodedKeystore = base64Decode(encodedKeystore);

    await DataSource.static.rawFile(keystoreFile).set(decodedKeystore);

    return keystoreFile;
  }

  Future<String> getEncodedKeystore(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('android/keystoreEncoded', () async {
      final apiKeyMethod = context.select(
        prompt: 'Provide a Keystore. '
            'This is used to sign your Android apps. '
            'There are two ways for you to provide this keystore:\n'
            '1) Follow the setup instructions at https://docs.flutter.dev/deployment/android#signing-the-app '
            'and submit the path to the .jks file.\n'
            '2) If you already have a base64-encoded keystore from another project, you can simply input that here.\n'
            'How would you like to import your API Key?',
        options: KeystoreRetrievalMethod.values,
        stringMapper: (method) => method.displayName,
      );

      return await apiKeyMethod.retrieveEncodedKeystore(context);
    });
  }

  Future<File> getKeyPropertiesFile(
    AutomateCommandContext context, {
    required String alias,
    required String password,
    required File keystoreFile,
  }) async {
    final keyPropertiesFile = context.appDirectory / 'android' - 'key.properties';

    final contents = {
      'storePassword': password,
      'keyPassword': password,
      'keyAlias': alias,
      'storeFile': keystoreFile.path,
    }.mapToIterable((key, value) => '$key=$value').join('\n');

    await DataSource.static.file(keyPropertiesFile).set(contents);

    return keyPropertiesFile;
  }

  Future<String> getKeystoreAlias(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('android/keystoreAlias', () async {
      final keystoreAlias = context.input('Provide the keystore alias.');
      if (keystoreAlias.isBlank) {
        throw Exception('Keystore alias not provided!');
      }

      return keystoreAlias;
    });
  }

  Future<String> getKeystorePassword(AutomateCommandContext context) async {
    return await context.getHiddenStateOrElse('android/keystorePassword', () async {
      final keystorePassword = context.input('Provide the keystore password.');
      if (keystorePassword.isBlank) {
        throw Exception('Keystore password not provided!');
      }

      return keystorePassword;
    });
  }
}

enum KeystoreRetrievalMethod {
  jksFile('jks file', _retrieveJksFileKeystore),
  encoded('encoded keystore', _retrieveEncodedKeystore);

  final String displayName;
  final Future<String> Function(AutomateCommandContext context) onRetrieveEncodedKeystore;

  const KeystoreRetrievalMethod(this.displayName, this.onRetrieveEncodedKeystore);

  Future<String> retrieveEncodedKeystore(AutomateCommandContext context) {
    return onRetrieveEncodedKeystore(context);
  }
}

Future<String> _retrieveJksFileKeystore(AutomateCommandContext context) async {
  final jksFileLocation = context.input('What is the path to your jks file?');
  if (jksFileLocation.isBlank) {
    throw Exception('.jks file not provided!');
  }

  final jksFile = File(jksFileLocation);
  final contents = await DataSource.static.rawFile(jksFile).get();
  return base64Encode(contents);
}

Future<String> _retrieveEncodedKeystore(AutomateCommandContext context) async {
  final encodedJks = context.input('What is your base64-encoded jks file?');
  if (encodedJks.isBlank) {
    throw Exception('Base64-encoded jks not provided!');
  }

  return encodedJks;
}
