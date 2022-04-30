class RemoteMessage {
  static const String codeResponse = 'RESPONSE';
  static const String codeExecuteCommand = 'EXECUTE_COMMAND';

  final String code;
  final String? id;
  final Map<String, dynamic> args;

  const RemoteMessage({required this.code, this.id, this.args: const {}});

  Map<String, dynamic> toJson() => {
        'code': code,
        if (id != null) 'id': id,
        'args': args,
      };

  static RemoteMessage fromJson(Map<String, dynamic> json) {
    return RemoteMessage(
      code: json['code'],
      id: json['id'],
      args: json['args'],
    );
  }
}
