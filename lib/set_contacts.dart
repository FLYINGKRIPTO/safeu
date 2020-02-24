import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:provider/provider.dart';
import 'package:safeu/database/dao.dart';
import 'package:safeu/database/database.dart' as db;

class SetPrimaryContacts extends StatefulWidget {
  @override
  _SetPrimaryContactsState createState() => _SetPrimaryContactsState();
}

class _SetPrimaryContactsState extends State<SetPrimaryContacts> {
  Iterable<Contact> contacts;
  bool showContactsList = false;
  List<Contact> emergencyContacts = [];
  ContactsDao contactsDao;
  Stream<List<db.Contact>> contactsFromDB;

  @override
  void didChangeDependencies() {
    contactsDao = Provider.of<ContactsDao>(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {
    getContacts(contacts);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    contactsFromDB = contactsDao?.allContacts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Primary contacts'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     GFButton(
                       text: "Select 3 people from your Contacts",
                       icon: Icon(Icons.people, color: Colors.blueAccent,),
                       shape: GFButtonShape.standard,
                       size: GFSize.LARGE,
                       onPressed: (){
                         setState(() {
                           showContactsList = true;
                         });
                       },
                       color: Colors.blueAccent,
                       padding: const EdgeInsets.all(8.0),
                       type: GFButtonType.outline2x,
                     ),

                     _buildListOfContacts(context),
                     Align(
                       alignment: Alignment.bottomRight,
                       child: GFButton(
                         shape: GFButtonShape.pills,
                         size: GFSize.SMALL,
                         text: "DONE",
                         icon: Icon(Icons.done),
                         onPressed: (){
                           setState(() {
                             showContactsList = false;
                           });
                         },
                       ),
                     ),
                   ],
                 ),
               ),
            ),
          ),
          showContactsList ? contacts == null ? Center(
            child: CircularProgressIndicator(semanticsLabel: "Loading Contacts",
            ),
          ): Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index){
              return ListTile(
                title: Text(contacts.toList()[index].displayName),
                onTap: (){
//
//                    if( == 3) {
//                      Scaffold.of(context).showSnackBar(SnackBar(
//                        content: Text("Cannot add more than 3 contacts"),
//                        duration: Duration(seconds: 3),
//                      ));
//                    }
//                    else {
                     _askConfirmationFromUser(contacts.toList()[index], context);
                   // }


                },
              );
            }, separatorBuilder: (context,index) => Divider(height: 1,), itemCount: contacts?.length ?? 1),
          ) : Container()
        ],
      ),
    );
  }
  StreamBuilder<List<db.Contact>> _buildListOfContacts(BuildContext context) {
    return
      StreamBuilder(
        stream: contactsFromDB,
        builder: (context, AsyncSnapshot<List<db.Contact>> snapshot){
          final cont = snapshot.data ?? [];
          return  ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context,index){
                final contVal = cont[index];
                return ListTile(
                  title: Text(contVal.name),
                  subtitle: Text(contVal.number),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      setState(() {
                           contactsDao.remove(contVal.id);
                      });

                    },
                  ),
                );
              }, itemCount: cont.length ?? 0) ;
        },
      );

  }
  getContacts(Iterable<Contact> contactst) async {
    contactst  = await ContactsService.getContacts();
    if(contactst != null){
      setState(() {
        contacts = contactst;
      });
    }
    contacts.toSet();
  }

  _askConfirmationFromUser(Contact contact,BuildContext context) {
    debugPrint('${contact.displayName}');
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Do you want to add ${ contact.displayName} ( ${ contact.phones != null ? contact.phones.first.value : "Unknown "} ) as your emergency contacts ? "),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                    setState(() {
                      emergencyContacts.add(contact);
                      contactsDao.add(name: contact.displayName,number: contact.phones.first.value.toString());
                      Navigator.pop(context);
                    });
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: (){
                  setState(() {
                     Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        }
    );
  }



}



