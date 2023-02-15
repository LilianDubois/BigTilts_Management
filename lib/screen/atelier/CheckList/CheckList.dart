import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_checkList.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/common/loading.dart';
import 'package:bigtitlss_management/models/checkLists.dart';
import 'package:bigtitlss_management/models/user.dart';

import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckList extends StatefulWidget {
  var btuid;
  CheckList(this.btuid);
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  final firestoreInstance = FirebaseFirestore.instance;
  bool darkmode = false;
  dynamic savedThemeMode;
  bool carton12complete = false;
  int compteur = 0;

  bool modulesVerinsLaterauxCarton1 = false;
  bool cableinterverinsCarton1 = false;
  bool modulesVerinsLaterauxCarton2 = false;
  bool modulesVerinsLaterauxCarton3 = false;
  bool modulesVerinsLaterauxCarton4 = false;
  bool modulesVerinsanglesCarton5 = false;
  bool modulesVerinsanglesCarton6 = false;
  bool modulesIntermediairesCarton7 = false;
  bool modulesIntermediairesCarton8 = false;
  bool moduleslaterauxbackCarton9 = false;
  bool moduleslaterauxfrontCarton10 = false;
  bool planchers = false;
  bool chassis = false;
  bool tapisWP = false;
  bool aspirateur = false;
  bool calesboisCarton11 = false;
  bool ordinateurCarton13 = false;
  bool check2 = false;
  bool check1 = false;
  bool cartonsComplete = false;

  bool _5m = false;
  bool _4m = false;
  bool _3m = false;

  Map<String, dynamic> stringslist;
  Map<String, dynamic> stringslistTools;

  void initState() {
    super.initState();
    getCurrentTheme();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUserData>>(context);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final checkListInstance = FirebaseFirestore.instance
        .collection("checkLists")
        .doc(widget.btuid)
        .collection('Checklist' + widget.btuid);
    final checkListDataInstance =
        FirebaseFirestore.instance.collection("checkLists");
    final stringsInstance = FirebaseFirestore.instance.collection("strings");

    final databaselogs = DatabaseLogs();

    final checkListlist = Provider.of<List<AppCheckListsData>>(context) ?? [];

    AppCheckListsData currentCheckList;
    var indexx = 0;

    while (checkListlist[indexx].id != int.parse(widget.btuid)) {
      indexx++;
    }

    AppUserData user;

    var indexuser = 0;
    while (users[indexuser].uid != firebaseUser.uid) {
      indexuser++;
    }
    user = users[indexuser];

    final databaseChecklists = DatabaseCheckLists(name: user.name);

    currentCheckList = checkListlist[indexx];
    check2 = currentCheckList.check2;
    check1 = currentCheckList.check1;
    tapisWP = currentCheckList.tapisWP;
    aspirateur = currentCheckList.aspirateur;
    planchers = currentCheckList.planchers;
    chassis = currentCheckList.chassis;

    DocumentReference<Map<String, dynamic>> stringsCheckListInstance;
    DocumentReference<Map<String, dynamic>> stringsToolsInstance;

    void verifcheck1() {
      print(modulesVerinsLaterauxCarton1);
      print(cableinterverinsCarton1);
      print(modulesVerinsLaterauxCarton2);
      print(modulesVerinsLaterauxCarton3);
      print(modulesVerinsLaterauxCarton4);
      print(modulesVerinsanglesCarton5);
      print(modulesVerinsanglesCarton6);
      print(modulesIntermediairesCarton7);
      print(modulesIntermediairesCarton8);
      print(moduleslaterauxbackCarton9);
      print(moduleslaterauxfrontCarton10);
      print(calesboisCarton11);
      print(planchers);
      print(tapisWP);
      print(carton12complete);
      if (modulesVerinsLaterauxCarton1 &&
          cableinterverinsCarton1 &&
          modulesVerinsLaterauxCarton2 &&
          modulesVerinsLaterauxCarton3 &&
          modulesVerinsLaterauxCarton4 &&
          modulesVerinsanglesCarton5 &&
          modulesVerinsanglesCarton6 &&
          modulesIntermediairesCarton7 &&
          modulesIntermediairesCarton8 &&
          moduleslaterauxbackCarton9 &&
          moduleslaterauxfrontCarton10 &&
          calesboisCarton11 &&
          planchers &&
          chassis &&
          tapisWP &&
          aspirateur &&
          ordinateurCarton13 &&
          carton12complete) {
        checkListDataInstance
            .doc(widget.btuid)
            .update({"check1": true, "check1user": user.name});
      } else {
        print('check1user');
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Attention"),
              content: Text(
                  "Il faut que touts les éléments soient validés pour pouvoir valider le premier check"),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(_);
                  },
                ),
              ],
            );
          },
          barrierDismissible: true,
        );
        checkListDataInstance
            .doc(widget.btuid.toString())
            .update({"check1": false, "check1user": user.name});
      }
    }

    Future getStrings() async {
      if (currentCheckList.taillebt == 5) {
        stringsCheckListInstance = stringsInstance.doc("checkLists_5m");
        stringsToolsInstance = stringsInstance.doc("tools_5m");
        stringsCheckListInstance
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              stringslist = documentSnapshot.data();
            });
          } else {
            print('Document does not exist on the database');
          }
        });
        stringsToolsInstance.get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              stringslistTools = documentSnapshot.data();
            });
          } else {
            print('Document does not exist on the database');
          }
        });
        _5m = true;
      } else if (currentCheckList.taillebt == 4) {
        stringsCheckListInstance = stringsInstance.doc("checkLists_4m");
        stringsToolsInstance = stringsInstance.doc("tools_4M");
        stringsCheckListInstance
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              stringslist = documentSnapshot.data();
            });
          } else {
            print('Document does not exist on the database');
          }
        });
        stringsToolsInstance.get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              stringslistTools = documentSnapshot.data();
            });
          } else {
            print('Document does not exist on the database');
          }
        });
        _4m = true;
      } else if (currentCheckList.taillebt == 3) {
        stringsCheckListInstance = stringsInstance.doc("checkLists_3m");
        stringsToolsInstance = stringsInstance.doc("tools_3m");
        stringsCheckListInstance
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              stringslist = documentSnapshot.data();
            });
          } else {
            print('Document does not exist on the database');
          }
        });
        stringsToolsInstance.get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(() {
              stringslistTools = documentSnapshot.data();
            });
          } else {
            print('Document does not exist on the database');
          }
        });
        _3m = true;
      }
    }

    getStrings();

    void update4m3m() {
      //boucle qui met les valeurs des cartonsComplete 3 et 4 a true pour les 4m et 3m

      if (currentCheckList.taillebt == 4) {
        modulesVerinsLaterauxCarton4 = true;
        databaseChecklists.saveSpecificCarton(
            int.parse(widget.btuid), 'Carton4', 'modulesVerinsLateraux', true);
      }
      if (currentCheckList.taillebt == 3) {
        modulesVerinsLaterauxCarton3 = true;
        modulesVerinsLaterauxCarton4 = true;
        modulesIntermediairesCarton8 = true;
        databaseChecklists.saveSpecificCarton(
            int.parse(widget.btuid), 'Carton3', 'modulesVerinsLateraux', true);
        databaseChecklists.saveSpecificCarton(
            int.parse(widget.btuid), 'Carton4', 'modulesVerinsLateraux', true);
        databaseChecklists.saveSpecificCarton(
            int.parse(widget.btuid), 'Carton8', 'modulesIntermediaires', true);
      }
    }

    //update4m3m();

    if (stringslist == null && stringslistTools == null)
      return Loading();
    else
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
            title: Text('Check List BT : ' + widget.btuid),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
              },
            ),
          ),
          body: Container(
              child: SingleChildScrollView(
            child: Column(
              children: [
                FractionallySizedBox(
                  child: Container(
                    height: 10,
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: new BoxDecoration(
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4),
                      borderRadius: new BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bigtilt : ' + widget.btuid,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Emplacement : ' +
                                    currentCheckList.palette.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Taille BT : ${currentCheckList.taillebt.toString()}m',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Caisse : ' +
                                    currentCheckList.caisse.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                check2
                    ? Text(
                        'Deuxième check validé par ${currentCheckList.check2user}',
                        style: TextStyle(color: Colors.green),
                      )
                    : check1
<<<<<<< Updated upstream
                        ? FlatButton(
=======
                        ? TextButton(
>>>>>>> Stashed changes
                            child: Column(
                              children: [
                                Text(
                                  'Valider le deuxième Check',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Premier check validé par ${currentCheckList.check1user}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
<<<<<<< Updated upstream
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 5,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(50)),
                            padding: EdgeInsets.all(20),
=======
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.green,
                                        width: 5,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                padding: EdgeInsets.all(20)),
>>>>>>> Stashed changes
                            onPressed: () {
                              if (currentCheckList.check1user == user.name) {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text("Attention"),
                                      content: Text(
                                          "Il est préférable que le 2ème Check soit validé par quelqu'un d'autre. Voulez vous continuer ?"),
                                      actions: [
<<<<<<< Updated upstream
                                        FlatButton(
=======
                                        TextButton(
>>>>>>> Stashed changes
                                          child: Text("Oui"),
                                          onPressed: () {
                                            setState(() {
                                              check2 = true;
                                            });
                                            print('check2user');
                                            checkListDataInstance
                                                .doc(widget.btuid.toString())
                                                .update({
                                              "check2": true,
                                              "check2user": user.name
                                            });

                                            Navigator.pop(_);
                                          },
                                        ),
<<<<<<< Updated upstream
                                        FlatButton(
=======
                                        TextButton(
>>>>>>> Stashed changes
                                          child: Text("Non"),
                                          onPressed: () {
                                            Navigator.pop(_);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  barrierDismissible: true,
                                );
                              } else {
                                setState(() {
                                  check2 = true;
                                });
                                print('check2user');
                                checkListDataInstance
                                    .doc(widget.btuid.toString())
                                    .update({
                                  "check2": true,
                                  "check2user": user.name
                                });
                              }
                            },
                          )
<<<<<<< Updated upstream
                        : FlatButton(
=======
                        : TextButton(
>>>>>>> Stashed changes
                            child: Text(
                              'Valider le premier Check',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
<<<<<<< Updated upstream
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 5,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(50)),
                            padding: EdgeInsets.all(20),
=======
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.green,
                                        width: 5,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                padding: EdgeInsets.all(20)),
>>>>>>> Stashed changes
                            onPressed: () {
                              verifcheck1();
                            },
                          ),
                SizedBox(height: 10),
                CheckboxListTile(
                    title: Text('Tapis wp'),
                    value: tapisWP,
                    onChanged: (bool newbox) {
                      if (newbox == true) {
                        databaselogs.saveLogs(
                            '${DateTime.now().toString()}',
                            user.name,
                            'a coché le champ TapisWP dans la Checklist ${widget.btuid.toString()} ',
                            DateTime.now().toString(),
                            widget.btuid.toString());
                        tapisWP = newbox;
                        checkListDataInstance
                            .doc(widget.btuid.toString())
                            .update({"tapisWP": tapisWP});
                      }
                    }),
                CheckboxListTile(
                    title: Text('Aspirateur'),
                    value: aspirateur,
                    onChanged: (bool newbox) {
                      if (newbox == true) {
                        databaselogs.saveLogs(
                            '${DateTime.now().toString()}',
                            user.name,
                            'a coché le champ aspirateur dans la Checklist ${widget.btuid.toString()} ',
                            DateTime.now().toString(),
                            widget.btuid.toString());
                        aspirateur = newbox;
                        checkListDataInstance
                            .doc(widget.btuid.toString())
                            .update({"aspirateur": aspirateur});
                      }
                    }),
                ExpansionTile(
                  title: Text('Plancher',
                      style: TextStyle(
                          color: planchers && chassis
                              ? Colors.green
                              : darkmode
                                  ? Colors.white
                                  : Colors.black)),
                  children: <Widget>[
                    CheckboxListTile(
                        title: Text('Planchers'),
                        value: planchers,
                        onChanged: (bool newbox) {
                          if (newbox == true) if (planchers == false) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("Attention"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Je confirme avoir : ",
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                          "- Vérifié l'emboitement du plancher"),
                                      SizedBox(height: 10),
                                      Text(
                                          "- Testé la bonne mise en place des bogeys"),
                                      SizedBox(height: 10),
                                      Text(
                                          "- Testé le positionnement des planches sur le chassis"),
                                    ],
                                  ),
                                  actions: [
<<<<<<< Updated upstream
                                    FlatButton(
=======
                                    TextButton(
>>>>>>> Stashed changes
                                      child: Text("Oui"),
                                      onPressed: () {
                                        databaselogs.saveLogs(
                                            '${DateTime.now().toString()}',
                                            user.name,
                                            'a coché le champ planchers dans la Checklist ${widget.btuid.toString()} ',
                                            DateTime.now().toString(),
                                            widget.btuid.toString());
                                        planchers = newbox;
                                        checkListDataInstance
                                            .doc(widget.btuid.toString())
                                            .update({"planchers": planchers});

                                        Navigator.pop(_);
                                      },
                                    ),
<<<<<<< Updated upstream
                                    FlatButton(
=======
                                    TextButton(
>>>>>>> Stashed changes
                                      child: Text("Non"),
                                      onPressed: () {
                                        Navigator.pop(_);
                                      },
                                    ),
                                  ],
                                );
                              },
                              barrierDismissible: true,
                            );
                          } else {
                            print('placnhers');
                            planchers = newbox;
                            checkListDataInstance
                                .doc(widget.btuid.toString())
                                .update({"planchers": planchers});
                          }
                        }),
                    CheckboxListTile(
                        title: Text('Châssis'),
                        value: chassis,
                        onChanged: (bool newbox) {
                          if (newbox == true) if (chassis == false) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("Attention"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Je confirme avoir : ",
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                          "- Vérifié les différents branchements"),
                                      SizedBox(height: 10),
                                      Text(
                                          "- Vérifié l'emplacement des étiquettes"),
                                    ],
                                  ),
                                  actions: [
<<<<<<< Updated upstream
                                    FlatButton(
=======
                                    TextButton(
>>>>>>> Stashed changes
                                      child: Text("Oui"),
                                      onPressed: () {
                                        databaselogs.saveLogs(
                                            '${DateTime.now().toString()}',
                                            user.name,
                                            'a coché le champ Chassis dans la Checklist ${widget.btuid.toString()} ',
                                            DateTime.now().toString(),
                                            widget.btuid.toString());
                                        chassis = newbox;
                                        checkListDataInstance
                                            .doc(widget.btuid.toString())
                                            .update({"chassis": chassis});
                                        Navigator.pop(_);
                                      },
                                    ),
<<<<<<< Updated upstream
                                    FlatButton(
=======
                                    TextButton(
>>>>>>> Stashed changes
                                      child: Text("Non"),
                                      onPressed: () {
                                        Navigator.pop(_);
                                      },
                                    ),
                                  ],
                                );
                              },
                              barrierDismissible: true,
                            );
                          } else {
                            print('chassis');
                            chassis = newbox;
                            checkListDataInstance
                                .doc(widget.btuid.toString())
                                .update({"chassis": chassis});
                          }
                        }),
                  ],
                ),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton1').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      modulesVerinsLaterauxCarton1 =
                          document["modulesVerinsLateraux"];
                      cableinterverinsCarton1 = document["cableinterverins"];

                      return ExpansionTile(
                        title: Text('Carton 1',
                            style: TextStyle(
                                color: modulesVerinsLaterauxCarton1 &&
                                        cableinterverinsCarton1
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['modulesVerinsLateraux']),
                              value: modulesVerinsLaterauxCarton1,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  if (modulesVerinsLaterauxCarton1 == false) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("Attention"),
                                          content: Text(
                                              "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                          actions: [
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Oui"),
                                              onPressed: () {
                                                update4m3m();
                                                modulesVerinsLaterauxCarton1 =
                                                    newbox;
                                                databaseChecklists
                                                    .saveSpecificCarton(
                                                        int.parse(widget.btuid),
                                                        'Carton1',
                                                        'modulesVerinsLateraux',
                                                        modulesVerinsLaterauxCarton1);

                                                Navigator.pop(_);
                                              },
                                            ),
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Non"),
                                              onPressed: () {
                                                Navigator.pop(_);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      barrierDismissible: true,
                                    );
                                  } else {
                                    update4m3m();
                                    modulesVerinsLaterauxCarton1 = newbox;
                                    databaseChecklists.saveSpecificCarton(
                                        int.parse(widget.btuid),
                                        'Carton1',
                                        'modulesVerinsLateraux',
                                        modulesVerinsLaterauxCarton1);
                                  }
                                }
                              }),
                          CheckboxListTile(
                              title: Text(stringslist['cablesInterVerins']),
                              value: cableinterverinsCarton1,
                              onChanged: (bool newbox1) {
                                if (newbox1 == true) {
                                  cableinterverinsCarton1 = newbox1;
                                  databaseChecklists.saveSpecificCarton(
                                      int.parse(widget.btuid),
                                      'Carton1',
                                      'cableinterverins',
                                      cableinterverinsCarton1);
                                }
                              }),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton2').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      modulesVerinsLaterauxCarton2 =
                          document["modulesVerinsLateraux"];

                      return ExpansionTile(
                        title: Text('Carton 2',
                            style: TextStyle(
                                color: modulesVerinsLaterauxCarton2
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title:
                                  Text(stringslist['modulesVerinsLateraux2']),
                              value: modulesVerinsLaterauxCarton2,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  if (modulesVerinsLaterauxCarton2 == false) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("Attention"),
                                          content: Text(
                                              "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                          actions: [
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Oui"),
                                              onPressed: () {
                                                modulesVerinsLaterauxCarton2 =
                                                    newbox;
                                                databaseChecklists
                                                    .saveSpecificCarton(
                                                        int.parse(widget.btuid),
                                                        'Carton2',
                                                        'modulesVerinsLateraux',
                                                        modulesVerinsLaterauxCarton2);

                                                Navigator.pop(_);
                                              },
                                            ),
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Non"),
                                              onPressed: () {
                                                Navigator.pop(_);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      barrierDismissible: true,
                                    );
                                  } else {
                                    modulesVerinsLaterauxCarton2 = newbox;
                                    databaseChecklists.saveSpecificCarton(
                                        int.parse(widget.btuid),
                                        'Carton2',
                                        'modulesVerinsLateraux',
                                        modulesVerinsLaterauxCarton2);
                                  }
                                }
                              }),
                        ],
                      );
                    }),
                _3m
                    ? SizedBox()
                    : StreamBuilder(
                        stream: checkListInstance.doc('Carton3').snapshots(),
                        builder: (context, snapshot) {
                          var document = snapshot.data;
                          modulesVerinsLaterauxCarton3 =
                              document["modulesVerinsLateraux"];

                          return ExpansionTile(
                            title: Text('Carton 3',
                                style: TextStyle(
                                    color: modulesVerinsLaterauxCarton3
                                        ? Colors.green
                                        : darkmode
                                            ? Colors.white
                                            : Colors.black)),
                            children: <Widget>[
                              CheckboxListTile(
                                  title: Text(
                                      stringslist['modulesVerinsLateraux3']),
                                  value: modulesVerinsLaterauxCarton3,
                                  onChanged: (bool newbox) {
                                    if (newbox == true) {
                                      if (modulesVerinsLaterauxCarton3 ==
                                          false) {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              title: Text("Attention"),
                                              content: Text(
                                                  "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                              actions: [
<<<<<<< Updated upstream
                                                FlatButton(
=======
                                                TextButton(
>>>>>>> Stashed changes
                                                  child: Text("Oui"),
                                                  onPressed: () {
                                                    modulesVerinsLaterauxCarton3 =
                                                        newbox;
                                                    databaseChecklists
                                                        .saveSpecificCarton(
                                                            int.parse(
                                                                widget.btuid),
                                                            'Carton3',
                                                            'modulesVerinsLateraux',
                                                            modulesVerinsLaterauxCarton3);

                                                    Navigator.pop(_);
                                                  },
                                                ),
<<<<<<< Updated upstream
                                                FlatButton(
=======
                                                TextButton(
>>>>>>> Stashed changes
                                                  child: Text("Non"),
                                                  onPressed: () {
                                                    Navigator.pop(_);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                          barrierDismissible: true,
                                        );
                                      } else {
                                        modulesVerinsLaterauxCarton3 = newbox;
                                        databaseChecklists.saveSpecificCarton(
                                            int.parse(widget.btuid),
                                            'Carton3',
                                            'modulesVerinsLateraux',
                                            modulesVerinsLaterauxCarton3);
                                      }
                                    }
                                  }),
                            ],
                          );
                        }),
                _3m
                    ? SizedBox()
                    : _4m
                        ? SizedBox()
                        : StreamBuilder(
                            stream:
                                checkListInstance.doc('Carton4').snapshots(),
                            builder: (context, snapshot) {
                              var document = snapshot.data;
                              modulesVerinsLaterauxCarton4 =
                                  document["modulesVerinsLateraux"];

                              return ExpansionTile(
                                title: Text('Carton 4',
                                    style: TextStyle(
                                        color: modulesVerinsLaterauxCarton4
                                            ? Colors.green
                                            : darkmode
                                                ? Colors.white
                                                : Colors.black)),
                                children: <Widget>[
                                  CheckboxListTile(
                                      title: Text(stringslist[
                                          'modulesVerinsLateraux4']),
                                      value: modulesVerinsLaterauxCarton4,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          if (modulesVerinsLaterauxCarton4 ==
                                              false) {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: Text("Attention"),
                                                  content: Text(
                                                      "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                                  actions: [
<<<<<<< Updated upstream
                                                    FlatButton(
=======
                                                    TextButton(
>>>>>>> Stashed changes
                                                      child: Text("Oui"),
                                                      onPressed: () {
                                                        modulesVerinsLaterauxCarton4 =
                                                            newbox;
                                                        databaseChecklists
                                                            .saveSpecificCarton(
                                                                int.parse(widget
                                                                    .btuid),
                                                                'Carton4',
                                                                'modulesVerinsLateraux',
                                                                modulesVerinsLaterauxCarton4);

                                                        Navigator.pop(_);
                                                      },
                                                    ),
<<<<<<< Updated upstream
                                                    FlatButton(
=======
                                                    TextButton(
>>>>>>> Stashed changes
                                                      child: Text("Non"),
                                                      onPressed: () {
                                                        Navigator.pop(_);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                              barrierDismissible: true,
                                            );
                                          } else {
                                            modulesVerinsLaterauxCarton4 =
                                                newbox;
                                            databaseChecklists.saveSpecificCarton(
                                                int.parse(widget.btuid),
                                                'Carton4',
                                                'modulesVerinsLateraux',
                                                modulesVerinsLaterauxCarton4);
                                          }
                                        }
                                      }),
                                ],
                              );
                            }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton5').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      modulesVerinsanglesCarton5 =
                          document["modulesVerinsangles"];

                      return ExpansionTile(
                        title: Text('Carton 5',
                            style: TextStyle(
                                color: modulesVerinsanglesCarton5
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['modulesVerinsAngles']),
                              value: modulesVerinsanglesCarton5,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  if (modulesVerinsanglesCarton5 == false) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("Attention"),
                                          content: Text(
                                              "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                          actions: [
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Oui"),
                                              onPressed: () {
                                                modulesVerinsanglesCarton5 =
                                                    newbox;
                                                databaseChecklists
                                                    .saveSpecificCarton(
                                                        int.parse(widget.btuid),
                                                        'Carton5',
                                                        'modulesVerinsangles',
                                                        modulesVerinsanglesCarton5);

                                                Navigator.pop(_);
                                              },
                                            ),
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Non"),
                                              onPressed: () {
                                                Navigator.pop(_);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      barrierDismissible: true,
                                    );
                                  } else {
                                    modulesVerinsanglesCarton5 = newbox;
                                    databaseChecklists.saveSpecificCarton(
                                        int.parse(widget.btuid),
                                        'Carton5',
                                        'modulesVerinsangles',
                                        modulesVerinsanglesCarton5);
                                  }
                                }
                              }),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton6').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      modulesVerinsanglesCarton6 =
                          document["modulesVerinsangles"];
                      return ExpansionTile(
                        title: Text('Carton 6',
                            style: TextStyle(
                                color: modulesVerinsanglesCarton6
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['modulesVerinsAngles2']),
                              value: modulesVerinsanglesCarton6,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  if (modulesVerinsanglesCarton6 == false) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("Attention"),
                                          content: Text(
                                              "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                          actions: [
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Oui"),
                                              onPressed: () {
                                                modulesVerinsanglesCarton6 =
                                                    newbox;
                                                databaseChecklists
                                                    .saveSpecificCarton(
                                                        int.parse(widget.btuid),
                                                        'Carton6',
                                                        'modulesVerinsangles',
                                                        modulesVerinsanglesCarton6);

                                                Navigator.pop(_);
                                              },
                                            ),
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Non"),
                                              onPressed: () {
                                                Navigator.pop(_);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      barrierDismissible: true,
                                    );
                                  } else {
                                    modulesVerinsanglesCarton6 = newbox;
                                    databaseChecklists.saveSpecificCarton(
                                        int.parse(widget.btuid),
                                        'Carton6',
                                        'modulesVerinsangles',
                                        modulesVerinsanglesCarton6);
                                  }
                                }
                              }),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton7').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      modulesIntermediairesCarton7 =
                          document["modulesIntermediaires"];

                      return ExpansionTile(
                        title: Text('Carton 7',
                            style: TextStyle(
                                color: modulesIntermediairesCarton7
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['modulesIntermediaires']),
                              value: modulesIntermediairesCarton7,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  modulesIntermediairesCarton7 = newbox;
                                  databaseChecklists.saveSpecificCarton(
                                      int.parse(widget.btuid),
                                      'Carton7',
                                      'modulesIntermediaires',
                                      modulesIntermediairesCarton7);
                                }
                              }),
                        ],
                      );
                    }),
                _3m
                    ? SizedBox()
                    : StreamBuilder(
                        stream: checkListInstance.doc('Carton8').snapshots(),
                        builder: (context, snapshot) {
                          var document = snapshot.data;
                          modulesIntermediairesCarton8 =
                              document["modulesIntermediaires"];

                          return ExpansionTile(
                            title: Text('Carton 8',
                                style: TextStyle(
                                    color: modulesIntermediairesCarton8
                                        ? Colors.green
                                        : darkmode
                                            ? Colors.white
                                            : Colors.black)),
                            children: <Widget>[
                              CheckboxListTile(
                                  title: Text(
                                      stringslist['modulesIntermediaires2']),
                                  value: modulesIntermediairesCarton8,
                                  onChanged: (bool newbox) {
                                    if (newbox == true) {
                                      modulesIntermediairesCarton8 = newbox;
                                      databaseChecklists.saveSpecificCarton(
                                          int.parse(widget.btuid),
                                          'Carton8',
                                          'modulesIntermediaires',
                                          modulesIntermediairesCarton8);
                                    }
                                  }),
                            ],
                          );
                        }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton9').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      moduleslaterauxbackCarton9 =
                          document["moduleslaterauxback"];

                      return ExpansionTile(
                        title: Text('Carton 9',
                            style: TextStyle(
                                color: moduleslaterauxbackCarton9
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['modulesLaterauxFront']),
                              value: moduleslaterauxbackCarton9,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  moduleslaterauxbackCarton9 = newbox;
                                  databaseChecklists.saveSpecificCarton(
                                      int.parse(widget.btuid),
                                      'Carton9',
                                      'moduleslaterauxback',
                                      moduleslaterauxbackCarton9);
                                }
                              }),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton10').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      moduleslaterauxfrontCarton10 =
                          document["moduleslaterauxfront"];

                      return ExpansionTile(
                        title: Text('Carton 10',
                            style: TextStyle(
                                color: moduleslaterauxfrontCarton10
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['modulesLaterauxBack']),
                              value: moduleslaterauxfrontCarton10,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  moduleslaterauxfrontCarton10 = newbox;
                                  databaseChecklists.saveSpecificCarton(
                                      int.parse(widget.btuid),
                                      'Carton10',
                                      'moduleslaterauxfront',
                                      moduleslaterauxfrontCarton10);
                                }
                              }),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton11').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      calesboisCarton11 = document["calesbois"];

                      return ExpansionTile(
                        title: Text('Carton 11',
                            style: TextStyle(
                                color: calesboisCarton11
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['calesBois']),
                              value: calesboisCarton11,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  calesboisCarton11 = newbox;
                                  databaseChecklists.saveSpecificCarton(
                                      int.parse(widget.btuid),
                                      'Carton11',
                                      'calesbois',
                                      calesboisCarton11);
                                }
                              }),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton12').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      bool _12boulonsM1425mm = document["12boulonsM1425mm"];
                      bool _12ecrousM14 = document["12ecrousM14"];
                      bool _112boulonsM1060mm = document["112boulonsM1060mm"];
                      bool _16ecrousM10 = document["16ecrousM10"];
                      bool _18boulonsM1030mm = document["18boulonsM1030mm"];
                      bool _18rondellesM1430mm = document["18rondellesM1430mm"];
                      bool _18plaquettesacier = document["18plaquettesacier"];
                      bool _8bogeys = document["8bogeys"];
                      bool _4visM8 = document["4visM8"];
                      bool _1niveaulaser = document["1niveaulaser"];
                      bool _7marqueballe = document["7marqueballe"];
                      bool _metre = document["metre"];
                      bool _sparebag = document["sparebag"];
                      bool _50clamps = document["50clamps"];
                      bool _2pairesdegants = document["2pairesdegants"];
                      bool _rangementtelec = document["rangementtelec"];
                      bool _cablealimetationadapte =
                          document["cablealimetationadapte"];
                      bool _adaptateurAspirateur =
                          document["adaptateurAspirateur"];

                      void carton12iscomplete() {
                        if (_12boulonsM1425mm &&
                            _12ecrousM14 &&
                            _112boulonsM1060mm &&
                            _16ecrousM10 &&
                            _18boulonsM1030mm &&
                            _18rondellesM1430mm &&
                            _18plaquettesacier &&
                            _8bogeys &&
                            _4visM8 &&
                            _1niveaulaser &&
                            _7marqueballe &&
                            _metre &&
                            _sparebag &&
                            _50clamps &&
                            _2pairesdegants &&
                            _rangementtelec &&
                            _cablealimetationadapte &&
                            _adaptateurAspirateur) {
                          carton12complete = true;
                        } else
                          carton12complete = false;
                      }

                      carton12iscomplete();

                      return ExpansionTile(
                        title: Text('Carton 12 (Tools)',
                            style: TextStyle(
                                color: carton12complete
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Chassis',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title:
                                          Text(stringslistTools['boulonsM14']),
                                      value: _12boulonsM1425mm,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _12boulonsM1425mm = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '12boulonsM1425mm',
                                              _12boulonsM1425mm);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title:
                                          Text(stringslistTools['ecrousM14']),
                                      value: _12ecrousM14,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _12ecrousM14 = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '12ecrousM14',
                                              _12ecrousM14);
                                          carton12iscomplete();
                                        }
                                      })),
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              ListTile(
                                  title: Text(
                                'Modules',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['boulonsM10_60mm']),
                                      value: _112boulonsM1060mm,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _112boulonsM1060mm = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '112boulonsM1060mm',
                                              _112boulonsM1060mm);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title:
                                          Text(stringslistTools['ecrousM10']),
                                      value: _16ecrousM10,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _16ecrousM10 = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '16ecrousM10',
                                              _16ecrousM10);
                                          carton12iscomplete();
                                        }
                                      })),
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Plancher',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['boulonsM10_30mm']),
                                      value: _18boulonsM1030mm,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _18boulonsM1030mm = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '18boulonsM1030mm',
                                              _18boulonsM1030mm);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['rondellesM10']),
                                      value: _18rondellesM1430mm,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _18rondellesM1430mm = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '18rondellesM1430mm',
                                              _18rondellesM1430mm);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['plaquesAcier']),
                                      value: _18plaquettesacier,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _18plaquettesacier = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '18plaquettesacier',
                                              _18plaquettesacier);
                                          carton12iscomplete();
                                        }
                                      })),
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Bogey',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['bogeys']),
                                      value: _8bogeys,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _8bogeys = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '8bogeys',
                                              _8bogeys);
                                          carton12iscomplete();
                                        }
                                      })),
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Socle/Tour',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['visM8']),
                                      value: _4visM8,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _4visM8 = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '4visM8',
                                              _4visM8);
                                          carton12iscomplete();
                                        }
                                      })),
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Niveau/Calibration',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['niveau']),
                                      value: _1niveaulaser,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _1niveaulaser = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '1niveaulaser',
                                              _1niveaulaser);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['marquesBalle']),
                                      value: _7marqueballe,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _7marqueballe = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '7marqueballe',
                                              _7marqueballe);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['metre']),
                                      value: _metre,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _metre = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              'metre',
                                              _metre);
                                          carton12iscomplete();
                                        }
                                      })),
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Autres',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['spareBag']),
                                      value: _sparebag,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _sparebag = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              'sparebag',
                                              _sparebag);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['clamps']),
                                      value: _50clamps,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _50clamps = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '50clamps',
                                              _50clamps);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(stringslistTools['gants']),
                                      value: _2pairesdegants,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _2pairesdegants = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              '2pairesdegants',
                                              _2pairesdegants);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['rangementTelec']),
                                      value: _rangementtelec,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _rangementtelec = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              'rangementtelec',
                                              _rangementtelec);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title:
                                          Text(stringslistTools['cableAlim']),
                                      value: _cablealimetationadapte,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _cablealimetationadapte = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              'cablealimetationadapte',
                                              _cablealimetationadapte);
                                          carton12iscomplete();
                                        }
                                      })),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          10), //apply padding to all four sides
                                  child: CheckboxListTile(
                                      title: Text(
                                          stringslistTools['AdaptAspirateur']),
                                      value: _adaptateurAspirateur,
                                      onChanged: (bool newbox) {
                                        if (newbox == true) {
                                          _adaptateurAspirateur = newbox;
                                          databaseChecklists.saveSpecificCarton(
                                              int.parse(widget.btuid),
                                              'Carton12',
                                              'adaptateurAspirateur',
                                              _adaptateurAspirateur);
                                          carton12iscomplete();
                                        }
                                      })),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ],
                      );
                    }),
                StreamBuilder(
                    stream: checkListInstance.doc('Carton13').snapshots(),
                    builder: (context, snapshot) {
                      var document = snapshot.data;
                      ordinateurCarton13 = document["ordinateur"];

                      return ExpansionTile(
                        title: Text('Carton 13',
                            style: TextStyle(
                                color: ordinateurCarton13
                                    ? Colors.green
                                    : darkmode
                                        ? Colors.white
                                        : Colors.black)),
                        children: <Widget>[
                          CheckboxListTile(
                              title: Text(stringslist['Ordinateur']),
                              value: ordinateurCarton13,
                              onChanged: (bool newbox) {
                                if (newbox == true) {
                                  if (ordinateurCarton13 == false) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("Attention"),
                                          content: Text(
                                              "Je confirme que toutes les vérifications nécéssaires sur l'ordinateur on bien été effectués"),
                                          actions: [
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Oui"),
                                              onPressed: () {
                                                update4m3m();
                                                ordinateurCarton13 = newbox;
                                                databaseChecklists
                                                    .saveSpecificCarton(
                                                        int.parse(widget.btuid),
                                                        'Carton13',
                                                        'ordinateur',
                                                        ordinateurCarton13);

                                                Navigator.pop(_);
                                              },
                                            ),
<<<<<<< Updated upstream
                                            FlatButton(
=======
                                            TextButton(
>>>>>>> Stashed changes
                                              child: Text("Non"),
                                              onPressed: () {
                                                Navigator.pop(_);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                      barrierDismissible: true,
                                    );
                                  } else {
                                    update4m3m();
                                    ordinateurCarton13 = newbox;
                                    databaseChecklists.saveSpecificCarton(
                                        int.parse(widget.btuid),
                                        'Carton13',
                                        'ordinateur',
                                        ordinateurCarton13);
                                  }
                                }
                              }),
                        ],
                      );
                    }),
                FractionallySizedBox(
                  child: Container(
                    height: 200,
                  ),
                ),
              ],
            ),
          )));
  }
}
