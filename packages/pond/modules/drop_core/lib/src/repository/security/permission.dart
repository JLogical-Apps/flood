abstract class Permission {
  static Permission get all => AllPermission();

  static Permission get none => NonePermission();

  static Permission get authenticated => AuthenticatedPermission();

  bool passes({required String? authenticatedUserId});
}

class AllPermission implements Permission {
  @override
  bool passes({required String? authenticatedUserId}) {
    return true;
  }
}

class NonePermission implements Permission {
  @override
  bool passes({required String? authenticatedUserId}) {
    return false;
  }
}

class AuthenticatedPermission implements Permission {
  @override
  bool passes({required String? authenticatedUserId}) {
    return authenticatedUserId != null;
  }
}
