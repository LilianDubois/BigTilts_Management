import 'package:bigtitlss_management/Services/authentification.dart';
import 'package:bigtitlss_management/Services/database.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_checkList.dart';
import 'package:bigtitlss_management/Services/notification_service.dart';
import 'package:bigtitlss_management/common/loading.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/checkLists.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/atelier/create_bigtilt_atelier.dart';

import 'package:bigtitlss_management/screen/home/bigtilts_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'AppDrawer.dart';
import 'bigtilt_list_atelier.dart';

class HomeScreen extends StatelessWidget {
  final AuthtificationService _auth = AuthtificationService();

  @override
  Widget build(BuildContext context) {
    NotificationService.initialize();
    final user = Provider.of<AppUser>(context);

    final database = DatabaseService(uid: user.uid);
    final databasebigtilts = DatabaseBigtilts();
    final databasechecklists = DatabaseCheckLists();

    final firestoreInstance = FirebaseFirestore.instance;

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
        child: DefaultTabController(
            initialIndex: userr.state == 2 ? 3 : 1,
            length: 6,
            child: Scaffold(
                appBar: AppBar(
                  brightness: Brightness.dark,
                  backgroundColor: Colors.black,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'Tout'),
                      Tab(text: 'Disponibles à la vente'),
                      Tab(text: 'Réservées '),
                      Tab(text: userr.state == 2 ? 'A produire' : 'Vendues'),
                      Tab(text: 'Expédiées'),
                      Tab(text: 'Livrés'),
                    ],
                  ),
                  title: Text(
                    'BigTilts',
                    style: TextStyle(fontFamily: 'Spaceage'),
                  ),
                  elevation: 0.0,
                  actions: <Widget>[
                    if (userr.state == 2)
                      StreamBuilder<AppUserData>(
                          stream: database.user,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              AppUserData userData = snapshot.data;
                              final bigtilts =
                                  Provider.of<List<AppBigTiltsData>>(context) ??
                                      [];

                              return TextButton.icon(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: Text('',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  return Navigator.push(context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return new CreateBigtiltAtelier(
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
                body: StreamBuilder<AppUserData>(
                    stream: database.user,
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        AppUserData userData = snapshot.data;
                        if (userData.state == 0)
                          return Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                'Bienvenue sur l\'application Bigtilts Management !!',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Tu n\'as pas été ajouté a un groupe. Il faut demander a Boris de t\'ajouter pour utiliser l\'application',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        else {
                          return TabBarView(children: <Widget>[
                            Container(
                              child: StreamBuilder<AppUserData>(
                                stream: database.user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    AppUserData userData = snapshot.data;
                                    if (userData.state == 2)
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsListAtelier(
                                                  userData.state, 'all');
                                            },
                                          ),
                                        )),
                                      );
                                    else
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsList(
                                                  userData.state, 'all');
                                            },
                                          ),
                                        )),
                                      );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder<AppUserData>(
                                stream: database.user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    AppUserData userData = snapshot.data;
                                    if (userData.state == 2)
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsListAtelier(
                                                  userData.state, 'available');
                                            },
                                          ),
                                        )),
                                      );
                                    else
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsList(
                                                  userData.state, 'available');
                                            },
                                          ),
                                        )),
                                      );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder<AppUserData>(
                                stream: database.user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    AppUserData userData = snapshot.data;
                                    if (userData.state == 2)
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsListAtelier(
                                                  userData.state, 'reserved');
                                            },
                                          ),
                                        )),
                                      );
                                    else
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsList(
                                                  userData.state, 'reserved');
                                            },
                                          ),
                                        )),
                                      );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder<AppUserData>(
                                stream: database.user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    AppUserData userData = snapshot.data;
                                    if (userData.state == 2)
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsListAtelier(
                                                  userData.state, 'sold');
                                            },
                                          ),
                                        )),
                                      );
                                    else
                                      return StreamProvider<
                                          List<AppBigTiltsData>>.value(
                                        initialData: [],
                                        value: databasebigtilts.bigtilts,
                                        child: Scaffold(
                                            body: Container(
                                          //  decoration: new BoxDecoration(color: Colors.black),
                                          child: StreamBuilder<AppBigTiltsData>(
                                            stream: databasebigtilts.bigtilt,
                                            builder: (context, snapshot) {
                                              return BigtiltsList(
                                                  userData.state, 'sold');
                                            },
                                          ),
                                        )),
                                      );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder<AppUserData>(
                                stream: database.user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return StreamProvider<
                                        List<AppBigTiltsData>>.value(
                                      initialData: [],
                                      value: databasebigtilts.bigtilts,
                                      child: Scaffold(
                                          body: Container(
                                        //  decoration: new BoxDecoration(color: Colors.black),
                                        child: StreamBuilder<AppBigTiltsData>(
                                          stream: databasebigtilts.bigtilt,
                                          builder: (context, snapshot) {
                                            return BigtiltsList(
                                                userData.state, 'dispatched');
                                          },
                                        ),
                                      )),
                                    );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder<AppUserData>(
                                stream: database.user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return StreamProvider<
                                        List<AppBigTiltsData>>.value(
                                      initialData: [],
                                      value: databasebigtilts.bigtilts,
                                      child: Scaffold(
                                          body: Container(
                                        //  decoration: new BoxDecoration(color: Colors.black),
                                        child: StreamBuilder<AppBigTiltsData>(
                                          stream: databasebigtilts.bigtilt,
                                          builder: (context, snapshot) {
                                            return BigtiltsList(
                                                userData.state, 'delivered');
                                          },
                                        ),
                                      )),
                                    );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                            )
                          ]);
                        }
                      }
                    }))));
  }
}
