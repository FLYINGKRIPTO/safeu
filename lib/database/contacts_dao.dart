import 'package:flutter/cupertino.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:safeu/database/dao.dart';
import 'package:safeu/database/database.dart';
import 'package:uuid/uuid.dart';

import 'definition.dart';

part 'contacts_dao.g.dart';

@UseDao(
  tables: [
    Contacts
  ]
)
class SqlContactsDao extends DatabaseAccessor<SafeUDB> with _$SqlContactsDaoMixin, ContactsDao {

   SafeUDB db;

   SqlContactsDao(this.db) : super(db);

  @override
  Future remove(String id) {
    return transaction(() async {
      await (delete(contacts)..where((contact) => contact.id.equals(id))).go();
    });
  }

  @override
  Future add({String id, String name, String number}) {
    final id = Uuid().v4();
    final contactsData = Contact(
      id: id,
      name: name,
      number: number
    );
    return transaction(() async {
      await into(contacts).insert(contactsData);
    });
  }

  @override
  Stream<List<Contact>> allContacts() =>
      select(contacts).watch();



}