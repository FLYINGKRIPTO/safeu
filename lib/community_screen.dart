import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
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
            MyPeople(),
            AllPeople(),
          ],
        )
      ),
    );
  }
}
class MyPeople extends StatefulWidget {
  @override
  _MyPeopleState createState() => _MyPeopleState();
}

class _MyPeopleState extends State<MyPeople> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class AllPeople extends StatefulWidget {
  @override
  _AllPeopleState createState() => _AllPeopleState();
}

class _AllPeopleState extends State<AllPeople> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}


