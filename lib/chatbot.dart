import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
class SafeUBot extends StatefulWidget {
  @override
  _SafeUBotState createState() => _SafeUBotState();
}

class _SafeUBotState extends State<SafeUBot> {
  String query;
  AuthGoogle authGoogle;
  AIResponse aiResponse;
  @override
  void initState() {
    _authenticate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SAFE U'),),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
                 onChanged: (text){
                   setState(() {
                     query  =text;
                   });
                 },
            ),
            RaisedButton(
              child: Text("SEND"),
              onPressed: (){
                 getAIResponse();
              },
            )
          ],
        ),
      ),
    );
  }

  void _authenticate() async {
    authGoogle = await AuthGoogle(fileJson: "assets/safeu-ovqlgq-25bb822afaa5.json").build();
  }

  void getAIResponse() async {

    if(query!= null && query.isNotEmpty){
      Dialogflow dialogFlow = Dialogflow(authGoogle: authGoogle,language: Language.english);
      debugPrint("dgds ${query}");
      aiResponse = await dialogFlow?.detectIntent(query);
      debugPrint(aiResponse.getMessage());
    }

  }


}
