import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:safeu/database/contacts_dao.dart';
import 'definition.dart';

part 'database.g.dart';

@UseMoor(tables:[
  Contacts,
], daos: [
  SqlContactsDao,
])

class SafeUDB extends _$SafeUDB{
  SafeUDB() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;


}
