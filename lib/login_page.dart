import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safeu/home_screen.dart';
import 'package:safeu/sign_in.dart';
import 'package:safeu/sign_in_with_email.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username, email, password;
  FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseReference databaseReference;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 150),
                _registerUserWidget(),
                SizedBox(height: 50),
                _signInButton(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _signInWithEmailButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerUserWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                hintText: "Shivanshu", labelText: "User Name"),
            onChanged: (text) {
              username = text;
            },
          ),
          TextField(
            decoration:
                InputDecoration(hintText: "Enter Email", labelText: "Email"),
            onChanged: (text) {
              email = text;
            },
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Enter Password", labelText: "Password"),
            onChanged: (text) {
              password = text;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                color: Colors.blueAccent,
                child: Text("Register"),
                textColor: Colors.white,
                onPressed: (){
                   handleSignUP(email,password,username).then((user){
                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (context) {
                           return SignInWithEmail();
                         },
                       ),
                     );
                   });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInWithEmailButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return SignInWithEmail();
              },
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/email.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Email',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> handleSignUP(String email, String password,String username) async {
     AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user;
     if(user != null){
       databaseReference = FirebaseDatabase.instance.reference().child("users").child(user.uid);
       databaseReference.set({
         'userId' : user.uid ?? "",
         'username' : user.displayName ?? username ??  "",
         'user_email' : user.email ?? "",
         'user_number' : user.phoneNumber?? "",
         'user_photoUrl' : user.photoUrl ?? "",
       });
     }
     return user;
  }
}
