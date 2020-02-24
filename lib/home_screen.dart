
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:safeu/community_screen.dart';
import 'package:safeu/login_page.dart';
import 'package:safeu/send_sms.dart';
import 'package:safeu/set_contacts.dart';
import 'package:safeu/sign_in.dart';

import 'database/dao.dart';
import 'database/database.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser ;
  ContactsDao contactsDao;
  StreamSubscription<FirebaseUser> _listener;
  Stream<List<Contact>> savedContacts;
  List<String> recipients = [];

  @override
  void didChangeDependencies() {
    contactsDao = Provider.of<ContactsDao>(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {

    _checkCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    savedContacts = contactsDao?.allContacts();
    savedContacts.listen((contact){
      contact.forEach((c) => recipients.add(c.number));
    });
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GFAvatar(backgroundImage: NetworkImage(_currentUser?.photoUrl ?? ""),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_currentUser?.displayName ?? " "),
                )
              ],
          ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
        ),
          ListTile(
            title: Text("Logout"),
            onTap: (){
              signOutGoogle();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Set Primary Contacts'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SetPrimaryContacts()));
            },
          ),
          ListTile(
            title: Text('My Community'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()));
            },
          )

        ],
      )
      ),
      appBar: AppBar(
        title: Text('Safe - U'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GFCard(
            boxFit: BoxFit.cover,
            title: GFListTile(
              title: Text('Send SMS to Primary contacts'),
              icon: GFIconButton(
                onPressed: (){},
                icon: Icon(Icons.sms),
              )
            ),
            content: Text("You can set your primary contacts here"),
            buttonBar: GFButtonBar(
              alignment: WrapAlignment.start,
              children: <Widget>[
                GFButton(
                  text : "Send sms to Primary contacts",
                  onPressed: (){

                   getLocationAndSendSMS("Your friend ${_currentUser.displayName} might be in some trouble, Kindly check out ,This was ${_currentUser.displayName}'s last location ",recipients);
                  },
                ),
                GFButton(
                   text : "Set Primary contacts",
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SetPrimaryContacts();
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
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
  void signOutGoogle() async {
    await googleSignIn.signOut().whenComplete((){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LoginPage();
          },
        ),
      );
    });

    print("User Sign Out");
  }

}


