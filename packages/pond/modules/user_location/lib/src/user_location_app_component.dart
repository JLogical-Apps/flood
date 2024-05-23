import 'package:auth/auth.dart';
import 'package:location/location.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

class UserLocationAppComponent with IsAppPondComponent {
  @override
  Future onLoad(AppPondContext context) async {
    context.authCoreComponent.accountX.whereLoaded().listen((account) {
      if (account == null) {
        context.find<LocationAppComponent>().disableTracking();
      } else {
        context.find<LocationAppComponent>().enableTracking(context);
      }
    });
  }
}
