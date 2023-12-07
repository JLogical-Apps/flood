class Account {
  final String accountId;
  final bool isAdmin;

  Account({required this.accountId, this.isAdmin = false});

  @override
  String toString() {
    return 'Account($accountId, $isAdmin)';
  }
}
