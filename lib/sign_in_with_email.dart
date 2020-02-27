import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';


class SignInWithEmail extends StatefulWidget {
  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  String email, password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

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
                  child: Text("Sign In"),
                  textColor: Colors.white,
                  onPressed: (){
                    handleSignIn(email,password).then((user){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
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
      ),
    );;
  }

  Future<FirebaseUser> handleSignIn(String email, String password) async{
     AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user;
     return user;
  }
}
