import 'package:drop_core/drop_core.dart';
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

  RepositorySecurity.all(Permission permission) : this.readWrite(read: permission, write: permission);

  RepositorySecurity.public() : this.all(Permission.all);

  RepositorySecurity.authenticated() : this.all(Permission.authenticated);

  RepositorySecurity.none() : this.all(Permission.none);

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
