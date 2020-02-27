import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:safeu/user_model.dart';
class AllPeople extends StatefulWidget {
  @override
  _AllPeopleState createState() => _AllPeopleState();
}

class _AllPeopleState extends State<AllPeople> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference relationShipReference ;
  FirebaseUser _currentUser ;
  StreamSubscription<FirebaseUser> _listener;
  List<User> _users = List();
  User user;
  @override
  void initState() {
    _checkCurrentUser();
    user  = User("","","");
    databaseReference.onChildAdded.listen(_onUserAdded);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (context ,DataSnapshot snapshot, Animation<double> animation,int index) {
                return  ListTile(
                  title: Text(snapshot.value['username']),
                  subtitle: Text(snapshot.value['user_email']),
                  onTap: (){
                    askUser(snapshot.value);
                  },
                );
              },
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

  void askUser(dynamic value) {
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Do you want to add ${value['username']} to important people ??"),
            actions: <Widget>[
              FlatButton(child: Text('YES'),
                onPressed: (){
                  Navigator.pop(context);
                  makeRelationShip(_currentUser.uid, value['userId']);
                },
              ),
              FlatButton(
                child: Text("NO"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  void makeRelationShip(String uid,  value) {
    if(value !=null && uid != null){
      relationShipReference = FirebaseDatabase.instance.reference().child("relation");
      relationShipReference.set({
        uid : value
      });
    }
  }


}

