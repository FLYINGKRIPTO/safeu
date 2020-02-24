import 'package:safeu/database/database.dart';

abstract class ContactsDao {
  Future add({String id, String name, String number});

  Future remove(String id);

  Stream<List<Contact>> allContacts();
}
