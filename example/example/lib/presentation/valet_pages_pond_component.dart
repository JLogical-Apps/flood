import 'package:example/presentation/pages/envelope_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/pages/login_page.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ValetPagesAppPondComponent with IsAppPondComponent {
  @override
  List<AppPage> get pages => [
        HomePage(),
        LoginPage(),
        EnvelopePage(),
      ];
}
