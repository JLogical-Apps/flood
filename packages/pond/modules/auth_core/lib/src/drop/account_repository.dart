import 'package:auth_core/src/drop/account.dart';
import 'package:auth_core/src/drop/account_entity.dart';
import 'package:auth_core/src/drop/auth_credentials.dart';
import 'package:auth_core/src/drop/email_auth_credentials.dart';
import 'package:auth_core/src/drop/phone_otp_auth_credentials.dart';
import 'package:drop_core/drop_core.dart';

class AccountRepository with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.forType<AccountEntity, AccountValueObject>(
    AccountEntity.new,
    AccountValueObject.new,
    entityTypeName: 'AccountEntity',
    valueObjectTypeName: 'Account',
  )
      .withEmbeddedAbstractType<AuthCredentialsValueObject>(valueObjectTypeName: 'AuthCredential')
      .withEmbeddedType<EmailAuthCredentialsValueObject>(EmailAuthCredentialsValueObject.new,
          valueObjectTypeName: 'EmailAuthCredential',
          valueObjectParents: [
        AuthCredentialsValueObject
      ]).withEmbeddedType<PhoneOtpAuthCredentialsValueObject>(PhoneOtpAuthCredentialsValueObject.new,
          valueObjectTypeName: 'PhoneOtpAuthCredential', valueObjectParents: [AuthCredentialsValueObject]);
}
