class AppwriteConsts {
  // https://github.com/utopia-php/database/blob/main/src/Database/Adapter/MariaDB.php#L1354
  static final int mediumTextSize = 65535 + 1;

  // https://github.com/utopia-php/database/blob/main/src/Database/Adapter/MariaDB.php#L1350C15-L1350C15
  static final int longTextSize = 16777215 + 1;

  // https://github.com/utopia-php/database/blob/main/src/Database/Adapter/SQL.php#L912C16-L912C21
  static final int varcharSize = 16381;

  static final String typeKey = 't_type';

  static final String taskFunctionName = 'flood-tasks';

  // https://appwrite.io/docs/products/functions/development#:~:text=the%20running%20function.-,APPWRITE_FUNCTION_PROJECT_ID,-The%20project%20ID
  static final String projectIdFunctionEnv = 'APPWRITE_FUNCTION_PROJECT_ID';

  static final String apiKeyFunctionEnv = 'APPWRITE_API_KEY';
  static final String endpointFunctionEnv = 'APPWRITE_ENDPOINT';
}
