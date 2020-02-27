import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:safeu/important_people.dart';
import 'package:safeu/user_model.dart';

import 'all_people.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Community"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "Important",),
              Tab(text: "People",)
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ImportantPeople(),
            AllPeople(),
          ],
        )
      ),
    );
  }


}

