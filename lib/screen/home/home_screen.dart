import 'package:bigtitlss_management/Services/authentification.dart';
import 'package:bigtitlss_management/Services/database.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/common/loading.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/atelier/create_bigtilt_atelier.dart';
import 'package:bigtitlss_management/screen/admin/create_bigtilt_admin.dart';
import 'package:bigtitlss_management/screen/commerciaux/create_bigtilt_commerciaux.dart';
import 'package:bigtitlss_management/screen/home/bigtilts_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'AppDrawer.dart';

class HomeScreen extends StatelessWidget {
  final AuthtificationService _auth = AuthtificationService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    final database = DatabaseService(uid: user.uid);
    final databasebigtilts = DatabaseBigtilts();

    final firestoreInstance = FirebaseFirestore.instance;

    Widget okButtonAtelier = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new HomeScreen()));
      },
    );

    AlertDialog alertAtelier = AlertDialog(
      title: Text("Erreur"),
      content: Text("Vous n'avez pas le droit de créer une BigTilt"),
      actions: [
        okButtonAtelier,
      ],
    );

    final users = Provider.of<List<AppUserData>>(context) ?? [];

    var firebaseUser = FirebaseAuth.instance.currentUser;
    AppUserData userr;

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    userr = users[index];

    return MultiProvider(
      providers: [
        StreamProvider<List<AppUserData>>.value(
          initialData: [],
          value: database.users,
        ),
        StreamProvider<List<AppBigTiltsData>>.value(
          initialData: [],
          value: databasebigtilts.bigtilts,
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
            title: Text(
              'BigTilts',
              style: TextStyle(fontFamily: 'Spaceage'),
            ),
            elevation: 0.0,
            actions: <Widget>[
              if (userr.state != 0)
                StreamBuilder<AppUserData>(
                    stream: database.user,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        AppUserData userData = snapshot.data;
                        final bigtilts =
                            Provider.of<List<AppBigTiltsData>>(context) ?? [];

                        return TextButton.icon(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label:
                              Text('', style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (userData.state == 4)
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return alertAtelier;
                                },
                                barrierDismissible: true,
                              );
                            else
                              return Navigator.push(context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                if (userData.state == 1)
                                  return new CreateBigtiltScreen(
                                      userData.state, bigtilts.length);
                                if (userData.state == 2)
                                  return new CreateBigtiltAtelier(
                                      userData.state, bigtilts.length);
                                if (userData.state == 3)
                                  return new CreateBigtiltCommerciaux(
                                      userData.state, bigtilts.length);
                              }));
                          },
                        );
                      } else {
                        return Loading();
                      }
                    })
            ],
          ),
          drawer: AppDrawer(),
          body: Container(
            child: StreamBuilder<AppUserData>(
              stream: database.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  AppUserData userData = snapshot.data;
                  if (userData.state == 0)
                    return Text(
                        'Tu n\'as pas été ajouté a un groupe. Il faut demander a Boris de t\'ajouter pour utiliser l\'application');
                  else
                    return StreamProvider<List<AppBigTiltsData>>.value(
                      initialData: [],
                      value: databasebigtilts.bigtilts,
                      child: Scaffold(
                          body: Container(
                        //  decoration: new BoxDecoration(color: Colors.black),
                        child: StreamBuilder<AppBigTiltsData>(
                          stream: databasebigtilts.bigtilt,
                          builder: (context, snapshot) {
                            return BigtiltsList(userData.state);
                          },
                        ),
                      )),
                    );
                } else {
                  return Loading();
                }
              },
            ),
          )),
    );
  }
}
