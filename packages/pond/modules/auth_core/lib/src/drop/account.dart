import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/drop/auth_credentials.dart';
import 'package:drop_core/drop_core.dart';

class AccountValueObject extends ValueObject {
  static const authCredentialField = 'authCredential';
  late final authCredentialProperty =
      field<AuthCredentialsValueObject>(name: authCredentialField).embedded().required();

  static const authCredentialKeyField = 'authCredentialKey';
  late final authCredentialKeyProperty =
      computed<String?>(name: authCredentialKeyField, computation: () => authCredentialProperty.valueOrNull?.key);

  static const accountIdField = 'accountId';
  late final accountIdProperty = field<String>(name: accountIdField).isNotBlank();

  static const adminField = 'admin';
  late final adminProperty = field<bool>(name: adminField).withFallback(() => false);

  @override
  List<ValueObjectBehavior> get behaviors =>
      super.behaviors + [authCredentialProperty, authCredentialKeyProperty, accountIdProperty, adminProperty];

  Account toAccount() {
    return Account(
      accountId: accountIdProperty.value,
      isAdmin: adminProperty.value,
    );
  }

  static AccountValueObject fromAccount(Account account, AuthCredentials credentials) {
    return AccountValueObject()
      ..accountIdProperty.set(account.accountId)
      ..adminProperty.set(account.isAdmin)
      ..authCredentialProperty.set(AuthCredentialsValueObject.fromAuthCredentials(credentials));
  }
}
