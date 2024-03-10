import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/email_auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/phone_otp_auth_credentials.dart';
import 'package:auth_core/src/drop/account.dart';
import 'package:drop_core/drop_core.dart';

class AccountEntity extends Entity<AccountValueObject> {
  static Query<AccountEntity> accountFromCredentialsQuery(AuthCredentials credentials) {
    final baseQuery = Query.from<AccountEntity>();
    if (credentials is EmailAuthCredentials) {
      return baseQuery.where(AccountValueObject.authCredentialKeyField).isEqualTo(credentials.email);
    } else if (credentials is PhoneOtpAuthCredentials) {
      return baseQuery.where(AccountValueObject.authCredentialKeyField).isEqualTo(credentials.phoneNumber);
    }

    throw UnimplementedError();
  }

  static Query<AccountEntity> accountFromIdQuery(String accountId) {
    return Query.from<AccountEntity>().where(AccountValueObject.accountIdField).isEqualTo(accountId);
  }
}
