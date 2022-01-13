import 'package:bigtitlss_management/Services/database_checkList.dart';
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
  bool tapisWP = false;
  bool calesboisCarton11 = false;
  bool check2 = false;
  bool check1 = false;
  bool cartonsComplete = false;

  bool _5m = false;
  bool _4m = false;
  bool _3m = false;

  List<String> stringslist;
  List<String> stringslistTools;

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

    final checkListlist = Provider.of<List<AppCheckListsData>>(context) ?? [];
    final databaseChecklists = DatabaseCheckLists();

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

    currentCheckList = checkListlist[indexx];
    check2 = currentCheckList.check2;
    check1 = currentCheckList.check1;
    tapisWP = currentCheckList.tapisWP;
    planchers = currentCheckList.planchers;

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
          tapisWP &&
          carton12complete) {
        checkListDataInstance
            .doc(widget.btuid)
            .update({"check1": true, "check1user": user.name});
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Attention"),
              content: Text(
                  "Il faut que touts les éléments soient validés pour pouvoir valider le premier check"),
              actions: [
                FlatButton(
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

    initState() {
      verifcheck1();
      print('init');
    }

    if (currentCheckList.taillebt == 5) {
      _5m = true;
      stringslist = [
        '2 Modules vérins latéraux',
        '8 câbles inter vérins',
        '2 Modules vérins latéraux',
        '2 Modules vérins latéraux',
        '2 Modules vérins latéraux',
        '2 Modules vérins angles',
        '2 Modules vérins angles',
        '5 Modules intermédiaires',
        '5 Modules intermédiaires',
        '4 Modules latéraux front',
        '4 Modules latéraux back',
        '12 Cales en bois'
      ];
      stringslistTools = [
        ' 20 Boulons M14 25mm',
        '20 Ecrous M14',
        '112 Boulons M10 60mm (2 bags)',
        '112 Ecrous M10',
        '30 Boulons M10 30mm',
        '30 Rondelles M10 30mm',
        '30 Plaques acier',
        '8 Bogeys',
        '4 vis M8',
        '1 Niveau Laser',
        '11 Marques balle',
        'Mètre',
        'Spare Bag',
        '25 Clamps',
        '2 Paires de gants',
        'Rangement telecommande',
        'Cable alimentation adapté',
      ];
    } else if (currentCheckList.taillebt == 4) {
      _4m = true;
      stringslist = [
        '2 Modules vérins latéraux',
        '6 câbles inter vérins',
        '2 Modules vérins latéraux',
        '2 Modules vérins latéraux',
        '   ',
        '2 Modules vérins angles',
        '2 Modules vérins angles',
        '4 Modules intermédiaires',
        '4 Modules intermédiaires',
        '4 Modules latéraux front',
        '4 Modules latéraux back',
        '10 Cales en bois'
      ];
      stringslistTools = [
        '15 Boulons M14 25mm',
        '15 Ecrous M14',
        '96 Boulons M10 60mm (2 bags)',
        '96 Ecrous M10',
        '24 Boulons M10 30mm',
        '24 Rondelles M10 30mm',
        '24 Plaques acier',
        '8 Bogeys',
        '4 vis M8',
        '1 Niveau Laser',
        '11 Marques balle',
        'Mètre',
        'Spare Bag',
        '25 Clamps',
        '2 Paires de gants',
        'Rangement telecommande',
        'Cable alimentation adapté',
      ];
    } else if (currentCheckList.taillebt == 3) {
      _3m = true;
      stringslist = [
        '2 Modules vérins latéraux',
        '4 câbles inter vérins',
        '2 Modules vérins latéraux',
        '   ',
        '   ',
        '2 Modules vérins angles',
        '2 Modules vérins angles',
        '3 Modules intermédiaires',
        '3 Modules intermédiaires',
        '4 Modules latéraux front',
        '4 Modules latéraux back',
        '8 Cales en bois'
      ];
      stringslistTools = [
        '10 Boulons M14 25mm',
        '10 Ecrous M14',
        '80 Boulons M10 60mm (2 bags)',
        '80 Ecrous M10',
        '18 Boulons M10 30mm',
        '18 Rondelles M10 30mm',
        '18 Plaques acier',
        '6 Bogeys',
        '4 vis M8',
        '1 Niveau Laser',
        '11 Marques balle',
        'Mètre',
        'Spare Bag',
        '25 Clamps',
        '2 Paires de gants',
        'Rangement telecommande',
        'Cable alimentation adapté',
      ];
    }

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
        databaseChecklists.saveSpecificCarton(
            int.parse(widget.btuid), 'Carton3', 'modulesVerinsLateraux', true);
        databaseChecklists.saveSpecificCarton(
            int.parse(widget.btuid), 'Carton4', 'modulesVerinsLateraux', true);
      }
    }

    update4m3m();

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
                              'Caisse : ' + currentCheckList.caisse.toString(),
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
                      ? FlatButton(
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
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.green,
                                  width: 5,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(20),
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
                                      FlatButton(
                                        child: Text("Oui"),
                                        onPressed: () {
                                          setState(() {
                                            check2 = true;
                                          });
                                          checkListDataInstance
                                              .doc(widget.btuid.toString())
                                              .update({
                                            "check2": true,
                                            "check2user": user.name
                                          });
                                          Navigator.pop(_);
                                        },
                                      ),
                                      FlatButton(
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
                              checkListDataInstance
                                  .doc(widget.btuid.toString())
                                  .update({
                                "check2": true,
                                "check2user": user.name
                              });
                            }
                          },
                        )
                      : FlatButton(
                          child: Text(
                            'Valider le premier Check',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.green,
                                  width: 5,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(20),
                          onPressed: () {
                            verifcheck1();
                          },
                        ),
              SizedBox(height: 10),
              CheckboxListTile(
                  title: Text('planchers'),
                  value: planchers,
                  onChanged: (bool newbox) {
                    if (newbox == true) if (planchers == false) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("Attention"),
                            content: Text(
                                "Je confirme avoir monté une première fois le plancher avant de le mettre en caisse"),
                            actions: [
                              FlatButton(
                                child: Text("Oui"),
                                onPressed: () {
                                  planchers = newbox;
                                  checkListDataInstance
                                      .doc(widget.btuid.toString())
                                      .update({"planchers": planchers});

                                  Navigator.pop(_);
                                },
                              ),
                              FlatButton(
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
                      planchers = newbox;
                      checkListDataInstance
                          .doc(widget.btuid.toString())
                          .update({"planchers": planchers});
                    }
                  }),
              CheckboxListTile(
                  title: Text('Tapis wp'),
                  value: tapisWP,
                  onChanged: (bool newbox) {
                    if (newbox == true) {
                      tapisWP = newbox;
                      checkListDataInstance
                          .doc(widget.btuid.toString())
                          .update({"tapisWP": tapisWP});
                    }
                  }),
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[0]),
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
                                          FlatButton(
                                            child: Text("Oui"),
                                            onPressed: () {
                                              update4m3m();
                                              modulesVerinsLaterauxCarton1 =
                                                  newbox;
                                              databaseChecklists.saveSpecificCarton(
                                                  int.parse(widget.btuid),
                                                  'Carton1',
                                                  'modulesVerinsLateraux',
                                                  modulesVerinsLaterauxCarton1);

                                              Navigator.pop(_);
                                            },
                                          ),
                                          FlatButton(
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
                            title: Text(stringslist[1]),
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[2]),
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
                                          FlatButton(
                                            child: Text("Oui"),
                                            onPressed: () {
                                              modulesVerinsLaterauxCarton2 =
                                                  newbox;
                                              databaseChecklists.saveSpecificCarton(
                                                  int.parse(widget.btuid),
                                                  'Carton2',
                                                  'modulesVerinsLateraux',
                                                  modulesVerinsLaterauxCarton2);

                                              Navigator.pop(_);
                                            },
                                          ),
                                          FlatButton(
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
                                      : Colors.black)),
                          children: <Widget>[
                            CheckboxListTile(
                                title: Text(stringslist[3]),
                                value: modulesVerinsLaterauxCarton3,
                                onChanged: (bool newbox) {
                                  if (newbox == true) {
                                    if (modulesVerinsLaterauxCarton3 == false) {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: Text("Attention"),
                                            content: Text(
                                                "Je confirme avoir vérifé le bon fonctionnement des vérins"),
                                            actions: [
                                              FlatButton(
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
                                              FlatButton(
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
                          stream: checkListInstance.doc('Carton4').snapshots(),
                          builder: (context, snapshot) {
                            var document = snapshot.data;
                            modulesVerinsLaterauxCarton4 =
                                document["modulesVerinsLateraux"];

                            return ExpansionTile(
                              title: Text('Carton 4',
                                  style: TextStyle(
                                      color: modulesVerinsLaterauxCarton4
                                          ? Colors.green
                                          : Colors.black)),
                              children: <Widget>[
                                CheckboxListTile(
                                    title: Text(stringslist[4]),
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
                                                  FlatButton(
                                                    child: Text("Oui"),
                                                    onPressed: () {
                                                      modulesVerinsLaterauxCarton4 =
                                                          newbox;
                                                      databaseChecklists
                                                          .saveSpecificCarton(
                                                              int.parse(
                                                                  widget.btuid),
                                                              'Carton4',
                                                              'modulesVerinsLateraux',
                                                              modulesVerinsLaterauxCarton4);

                                                      Navigator.pop(_);
                                                    },
                                                  ),
                                                  FlatButton(
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
                                          modulesVerinsLaterauxCarton4 = newbox;
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[5]),
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
                                          FlatButton(
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
                                          FlatButton(
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[6]),
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
                                          FlatButton(
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
                                          FlatButton(
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[7]),
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
              StreamBuilder(
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[8]),
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[9]),
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[10]),
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
                                  : Colors.black)),
                      children: <Widget>[
                        CheckboxListTile(
                            title: Text(stringslist[11]),
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
                          _cablealimetationadapte) {
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[0]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[1]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[2]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[3]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[4]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[5]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[6]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[7]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[8]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[9]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[10]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[11]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[12]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[13]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[14]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[15]),
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
                                    left: 10), //apply padding to all four sides
                                child: CheckboxListTile(
                                    title: Text(stringslistTools[16]),
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
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
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
