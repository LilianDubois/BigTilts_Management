import 'package:bigtitlss_management/Services/database.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/home/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAdminScreen extends StatefulWidget {
  @override
  _UserAdminScreenState createState() => _UserAdminScreenState();
}

class _UserAdminScreenState extends State<UserAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    final database = DatabaseService(uid: user.uid);
    final firestoreInstance = FirebaseFirestore.instance;

    return StreamProvider<List<AppUserData>>.value(
      initialData: [],
      value: database.users,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'utilisateurs',
            style: TextStyle(fontFamily: 'Spaceage'),
          ),
        ),
        body: Container(child: UserList()),
      ),
    );
  }
}
