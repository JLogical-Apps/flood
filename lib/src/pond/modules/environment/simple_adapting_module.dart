import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/modules/environment/adapting_module.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment.dart';

class SimpleAdaptingModule<T extends AppModule> extends AdaptingModule<T> {
  final T? Function(Environment environment) moduleGetter;

  SimpleAdaptingModule({required this.moduleGetter});

  @override
  T? getModule(Environment environment) {
    return moduleGetter(environment);
  }
}
