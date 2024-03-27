import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/auth/signup_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/pages/outdated_page.dart';
import 'package:flood/flood.dart';

class PagesPondComponent with IsAppPondComponent {
  @override
  Map<Route, AppPage> get pages => {
        LoginRoute(): LoginPage(),
        SignupRoute(): SignupPage(),
        HomeRoute(): HomePage(),
        OutdatedRoute(): OutdatedPage(),
      };
}
