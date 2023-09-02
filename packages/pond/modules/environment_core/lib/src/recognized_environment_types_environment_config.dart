import 'package:collection/collection.dart';
import 'package:environment_core/environment_core.dart';

class RecognizedEnvironmentTypesEnvironmentConfig with IsEnvironmentConfigWrapper {
  @override
  final EnvironmentConfig environmentConfig;

  final List<EnvironmentType> recognizedEnvironmentTypes;

  RecognizedEnvironmentTypesEnvironmentConfig({
    required this.environmentConfig,
    required this.recognizedEnvironmentTypes,
  });

  @override
  Future<EnvironmentType> getEnvironmentType() async {
    final environmentValue = await environmentConfig.getOrNull<String>('environment');
    if (environmentValue == null) {
      return EnvironmentType.static.production;
    }

    return recognizedEnvironmentTypes.firstWhereOrNull((environmentType) => environmentType.name == environmentValue) ??
        EnvironmentType.static.production;
  }
}
