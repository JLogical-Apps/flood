import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/auth/signup_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ValetPagesAppPondComponent with IsAppPondComponent {
  @override
  Map<Route, AppPage> get pages => {
        LoginRoute(): LoginPage(),
        SignupRoute(): SignupPage(),
        HomeRoute(): HomePage(),
      };
}
