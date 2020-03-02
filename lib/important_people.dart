import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:safeu/user_model.dart';
class ImportantPeople extends StatefulWidget {
  @override
  _ImportantPeopleState createState() => _ImportantPeopleState();
}

class _ImportantPeopleState extends State<ImportantPeople> {
  DatabaseReference relationDatabaseReference = FirebaseDatabase.instance.reference().child("relation");
  DatabaseReference userDatabaseReference = FirebaseDatabase.instance.reference().child("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser ;
  StreamSubscription<FirebaseUser> _listener;
  List<User> _users = List();
  User user;
  @override
  void initState() {
    _checkCurrentUser();
    user  = User("","","");
    relationDatabaseReference.onChildAdded.listen(_onUserAdded);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: relationDatabaseReference,
              itemBuilder: (context ,DataSnapshot snapshot, Animation<double> animation,int index) {
                return
                  ListTile(
                  title: Text(snapshot.value[_currentUser.uid] ?? ""),
                  onTap: (){

                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                elevation: 4.0,
                child: Icon(Icons.notifications_active),
                onPressed: (){

                },
              ),
            ),
          )
        ],
      ),
    );
  }
  _onUserAdded(Event event){
    setState(() {
      _users.add(User.fromSnapshot(event.snapshot));
    });
  }
  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);
    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }
}
