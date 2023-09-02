import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example/presentation/pages/budget/budgets_page.dart';
import 'package:example/presentation/pages/envelope/archived_envelopes_page.dart';
import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/pages/transaction/add_transactions_page.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ValetPagesAppPondComponent with IsAppPondComponent {
  @override
  List<AppPage> get pages => [
        LoginPage(),
        HomePage(),
        BudgetsPage(),
        BudgetPage(),
        ArchivedEnvelopesPage(),
        AddTransactionsPage(),
        EnvelopePage(),
      ];
}
