
import 'package:moor_flutter/moor_flutter.dart';

class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get number => text()();
}