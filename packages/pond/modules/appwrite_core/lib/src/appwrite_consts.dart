class AppwriteConsts {
  // https://github.com/utopia-php/database/blob/main/src/Database/Adapter/MariaDB.php#L1354
  static final int mediumTextSize = 65535 + 1;

  // https://github.com/utopia-php/database/blob/main/src/Database/Adapter/MariaDB.php#L1350C15-L1350C15
  static final int longTextSize = 16777215 + 1;

  // https://github.com/utopia-php/database/blob/main/src/Database/Adapter/SQL.php#L912C16-L912C21
  static final int varcharSize = 16381;

  static final String typeKey = 't_type';
}
