import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite/appwrite.dart' hide Account;
import 'package:appwrite_app/src/util/appwrite_core_component_extensions.dart';
import 'package:auth_core/auth_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class AppwriteAuthService with IsAuthService, IsCorePondComponent {
  late final BehaviorSubject<FutureValue<Account?>> _accountX = BehaviorSubject.seeded(FutureValue.loading());

  late final appwrite.Account account = appwrite.Account(context.client);

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            try {
              final user = await account.get();
              _accountX.value = FutureValue.loaded(Account(
                accountId: user.$id,
                isAdmin: user.labels.contains('admin'),
              ));
            } catch (error, stackTrace) {
              _accountX.value = FutureValue.error(error, stackTrace);
            }
          },
        ),
      ];

  @override
  Future<Account> login(String email, String password) async {
    try {
      await account.createEmailSession(email: email, password: password);

      final user = await account.get();

      final loggedInAccount = Account(
        accountId: user.$id,
        isAdmin: user.labels.contains('admin'),
      );
      _accountX.value = FutureValue.loaded(loggedInAccount);
      return loggedInAccount;
    } on AppwriteException catch (e) {
      switch (e.type) {
        case 'user_invalid_credentials':
          throw LoginFailure.wrongPassword();
        case 'user_blocked':
          throw LoginFailure.userDisabled();
        case 'user_not_found':
          throw LoginFailure.userNotFound();
        case 'user_password_reset_required':
          throw LoginFailure.passwordResetRequired();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<Account> signup(String email, String password) async {
    try {
      final user = await account.create(userId: ID.unique(), email: email, password: password);
      await account.createEmailSession(email: email, password: password);

      final loggedInAccount = Account(
        accountId: user.$id,
        isAdmin: user.labels.contains('admin'),
      );

      _accountX.value = FutureValue.loaded(loggedInAccount);
      return loggedInAccount;
    } on AppwriteException catch (e) {
      switch (e.type) {
        case 'user_invalid_credentials':
          throw SignupFailure.invalidEmail();
        case 'user_already_exists':
        case 'user_email_already_exists':
          throw SignupFailure.emailAlreadyUsed();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<void> delete() async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await account.deleteSessions();
    _accountX.value = FutureValue.loaded(null);
  }

  @override
  ValueStream<FutureValue<Account?>> get accountX => _accountX;
}
