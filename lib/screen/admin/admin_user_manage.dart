import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:provider/provider.dart';
import 'package:bigtitlss_management/Services/database.dart';

class UserManage extends StatefulWidget {
  var name;
  var state;
  var uid = '3';
  UserManage({this.uid, this.name, this.state});

  @override
  _UserManageState createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  List<DropdownMenuItem<String>> listgroups = [];
  String def = null;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  void groups() {
    listgroups.clear();
    listgroups.add(
      DropdownMenuItem(
        value: '1',
        child: Text('admin'),
      ),
    );
    listgroups.add(
      DropdownMenuItem(
        value: '2',
        child: Text('atelier'),
      ),
    );
    listgroups.add(
      DropdownMenuItem(
        value: '3',
        child: Text('commerciaux'),
      ),
    );
    listgroups.add(
      DropdownMenuItem(
        value: '4',
        child: Text('Dev'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = DatabaseService(uid: widget.uid);

    groups();
    return StreamProvider<List<AppUserData>>.value(
      initialData: [],
      value: database.users,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.name),
        ),
        body: Container(
            child: Center(
                child: Column(
          children: <Widget>[
            SizedBox(height: 100),
            Center(
              child: Text(
                'Modifier le groupe de l\'utilisateur',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: DropdownButton(
                  value: def,
                  //elevation: 10,
                  items: listgroups,
                  hint: Text('selectioner un nouveau groupe'),
                  onChanged: (value) {
                    def = value;
                    setState(() {});
                  }),
            ),
            SizedBox(height: 20),
            Container(
                child: FlatButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.blue, width: 5, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.all(20),
              child: Text('Appliquer'),
              onPressed: () async {
                await database.saveUser(widget.name, int.parse(def));
              },
            )),
            SizedBox(height: 20),
            Container(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.red, width: 5, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.all(20),
                child: Text(
                  'Suprimer l\'utilisateur',
                ),
                onPressed: () async {
                  return userCollection.doc(widget.uid).delete();
                },
              ),
            )
          ],
        ))),
      ),
    );
  }
}
