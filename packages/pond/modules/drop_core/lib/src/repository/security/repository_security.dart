import 'package:drop_core/src/repository/security/permission.dart';

class RepositorySecurity {
  final Permission read;
  final Permission create;
  final Permission update;
  final Permission delete;

  RepositorySecurity({required this.read, required this.create, required this.update, required this.delete});

  RepositorySecurity.readWrite({required this.read, required Permission write})
      : create = write,
        update = write,
        delete = write;

  RepositorySecurity.public() : this.readWrite(read: Permission.all, write: Permission.all);

  RepositorySecurity copyWith({Permission? read, Permission? create, Permission? update, Permission? delete}) {
    return RepositorySecurity(
      read: read ?? this.read,
      create: create ?? this.create,
      update: update ?? this.update,
      delete: delete ?? this.delete,
    );
  }

  RepositorySecurity withRead(Permission read) {
    return copyWith(read: read);
  }

  RepositorySecurity withWrite(Permission write) {
    return copyWith(create: write, update: write, delete: write);
  }
}
