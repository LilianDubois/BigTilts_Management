import 'package:bigtitlss_management/Services/database_checkList.dart';
import 'package:bigtitlss_management/models/checkLists.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/atelier/CheckList/Tools.dart';
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

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUserData>>(context);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final checkListInstance = FirebaseFirestore.instance
        .collection("checkLists")
        .doc(widget.btuid)
        .collection('Checklist' + widget.btuid);

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
          tapisWP) {
        cartonsComplete = true;
        if (carton12complete)
          databaseChecklists.saveCheckList(
              int.parse(widget.btuid),
              currentCheckList.palette,
              currentCheckList.caisse,
              currentCheckList.taillebt,
              planchers,
              tapisWP,
              true,
              check2,
              user.name,
              currentCheckList.check2user);
      } else {
        cartonsComplete = false;
        check2 = false;
        databaseChecklists.saveCheckList(
            int.parse(widget.btuid),
            currentCheckList.palette,
            currentCheckList.caisse,
            currentCheckList.taillebt,
            planchers,
            tapisWP,
            false,
            check2,
            'none',
            'none');
      }
      ;
    }

    initState() {
      Future.delayed(const Duration(milliseconds: 2000), () {
        verifcheck1();
        print('init');
      });
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
    }

    void update4m3m() {
      //boucle qui met les valeurs des cartonsComplete 3 et 4 a true pour les 4m et 3m

      if (currentCheckList.taillebt == 4) {
        modulesVerinsLaterauxCarton4 = true;
        databaseChecklists.saveCheckListCartons(
            'Carton4',
            int.parse(widget.btuid),
            true,
            false,
            false,
            false,
            false,
            false,
            false);
      }
      if (currentCheckList.taillebt == 3) {
        modulesVerinsLaterauxCarton3 = true;
        modulesVerinsLaterauxCarton4 = true;
        databaseChecklists.saveCheckListCartons(
            'Carton3',
            int.parse(widget.btuid),
            true,
            false,
            false,
            false,
            false,
            false,
            false);
        databaseChecklists.saveCheckListCartons(
            'Carton4',
            int.parse(widget.btuid),
            true,
            false,
            false,
            false,
            false,
            false,
            false);
      }
    }

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
                                          databaseChecklists.saveCheckList(
                                              int.parse(widget.btuid),
                                              currentCheckList.palette,
                                              currentCheckList.caisse,
                                              currentCheckList.taillebt,
                                              planchers,
                                              tapisWP,
                                              true,
                                              true,
                                              currentCheckList.check1user,
                                              user.name);
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
                              databaseChecklists.saveCheckList(
                                  int.parse(widget.btuid),
                                  currentCheckList.palette,
                                  currentCheckList.caisse,
                                  currentCheckList.taillebt,
                                  planchers,
                                  tapisWP,
                                  true,
                                  true,
                                  currentCheckList.check1user,
                                  user.name);
                            }
                          },
                        )
                      : SizedBox(height: 0),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => ToolsScreen(
                              widget.btuid,
                              currentCheckList.taillebt,
                              cartonsComplete)));
                },
                child: FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                              color: darkmode ? Colors.white : Colors.black,
                              width: 2),
                        ),
                        child: StreamBuilder(
                            stream:
                                checkListInstance.doc('Carton12').snapshots(),
                            builder: (context, snapshot) {
                              var document = snapshot.data;
                              carton12complete = document["complete"];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Carton 12 Tools",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: carton12complete
                                                  ? Colors.green
                                                  : Colors.blue)),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ],
                              );
                            }))),
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                  title: Text('planchers'),
                  value: planchers,
                  onChanged: (bool newbox) {
                    if (planchers == false) {
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
                                  databaseChecklists.saveCheckList(
                                      int.parse(widget.btuid),
                                      currentCheckList.palette,
                                      currentCheckList.caisse,
                                      currentCheckList.taillebt,
                                      planchers,
                                      tapisWP,
                                      false,
                                      false,
                                      currentCheckList.check1user,
                                      currentCheckList.check2user);
                                  Future.delayed(
                                      const Duration(milliseconds: 2000), () {
                                    verifcheck1();
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
                      planchers = newbox;
                      databaseChecklists.saveCheckList(
                          int.parse(widget.btuid),
                          currentCheckList.palette,
                          currentCheckList.caisse,
                          currentCheckList.taillebt,
                          planchers,
                          tapisWP,
                          false,
                          false,
                          currentCheckList.check1user,
                          currentCheckList.check2user);
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        verifcheck1();
                      });
                    }
                  }),
              CheckboxListTile(
                  title: Text('Tapis wp'),
                  value: tapisWP,
                  onChanged: (bool newbox) {
                    tapisWP = newbox;
                    databaseChecklists.saveCheckList(
                        int.parse(widget.btuid),
                        currentCheckList.palette,
                        currentCheckList.caisse,
                        currentCheckList.taillebt,
                        planchers,
                        tapisWP,
                        false,
                        false,
                        currentCheckList.check1user,
                        currentCheckList.check2user);
                    verifcheck1();
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
                                            databaseChecklists
                                                .saveCheckListCartons(
                                                    'Carton1',
                                                    int.parse(widget.btuid),
                                                    modulesVerinsLaterauxCarton1,
                                                    cableinterverinsCarton1,
                                                    false,
                                                    false,
                                                    false,
                                                    false,
                                                    false);
                                            verifcheck1();
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
                                databaseChecklists.saveCheckListCartons(
                                    'Carton1',
                                    int.parse(widget.btuid),
                                    modulesVerinsLaterauxCarton1,
                                    cableinterverinsCarton1,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false);
                                verifcheck1();
                              }
                            }),
                        CheckboxListTile(
                            title: Text(stringslist[1]),
                            value: cableinterverinsCarton1,
                            onChanged: (bool newbox1) {
                              cableinterverinsCarton1 = newbox1;
                              databaseChecklists.saveCheckListCartons(
                                  'Carton1',
                                  int.parse(widget.btuid),
                                  modulesVerinsLaterauxCarton1,
                                  cableinterverinsCarton1,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false);
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                verifcheck1();
                              });
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
                                            databaseChecklists
                                                .saveCheckListCartons(
                                                    'Carton2',
                                                    int.parse(widget.btuid),
                                                    modulesVerinsLaterauxCarton2,
                                                    false,
                                                    false,
                                                    false,
                                                    false,
                                                    false,
                                                    false);
                                            verifcheck1();
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
                                databaseChecklists.saveCheckListCartons(
                                    'Carton2',
                                    int.parse(widget.btuid),
                                    modulesVerinsLaterauxCarton2,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false);
                                verifcheck1();
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
                                                    .saveCheckListCartons(
                                                        'Carton3',
                                                        int.parse(widget.btuid),
                                                        modulesVerinsLaterauxCarton3,
                                                        false,
                                                        false,
                                                        false,
                                                        false,
                                                        false,
                                                        false);
                                                verifcheck1();
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
                                    databaseChecklists.saveCheckListCartons(
                                        'Carton3',
                                        int.parse(widget.btuid),
                                        modulesVerinsLaterauxCarton3,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false);
                                    verifcheck1();
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
                                                        .saveCheckListCartons(
                                                            'Carton4',
                                                            int.parse(
                                                                widget.btuid),
                                                            modulesVerinsLaterauxCarton4,
                                                            false,
                                                            false,
                                                            false,
                                                            false,
                                                            false,
                                                            false);
                                                    verifcheck1();
                                                    verifcheck1();
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
                                        databaseChecklists.saveCheckListCartons(
                                            'Carton4',
                                            int.parse(widget.btuid),
                                            modulesVerinsLaterauxCarton4,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false,
                                            false);
                                        verifcheck1();
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
                                            modulesVerinsanglesCarton5 = newbox;
                                            databaseChecklists
                                                .saveCheckListCartons(
                                                    'Carton5',
                                                    int.parse(widget.btuid),
                                                    false,
                                                    false,
                                                    modulesVerinsanglesCarton5,
                                                    false,
                                                    false,
                                                    false,
                                                    false);
                                            verifcheck1();
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
                                databaseChecklists.saveCheckListCartons(
                                    'Carton5',
                                    int.parse(widget.btuid),
                                    false,
                                    false,
                                    modulesVerinsanglesCarton5,
                                    false,
                                    false,
                                    false,
                                    false);
                                verifcheck1();
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
                                            modulesVerinsanglesCarton6 = newbox;
                                            databaseChecklists
                                                .saveCheckListCartons(
                                                    'Carton6',
                                                    int.parse(widget.btuid),
                                                    false,
                                                    false,
                                                    modulesVerinsanglesCarton6,
                                                    false,
                                                    false,
                                                    false,
                                                    false);
                                            verifcheck1();
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
                                databaseChecklists.saveCheckListCartons(
                                    'Carton6',
                                    int.parse(widget.btuid),
                                    false,
                                    false,
                                    modulesVerinsanglesCarton6,
                                    false,
                                    false,
                                    false,
                                    false);
                                verifcheck1();
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
                              modulesIntermediairesCarton7 = newbox;
                              databaseChecklists.saveCheckListCartons(
                                  'Carton7',
                                  int.parse(widget.btuid),
                                  false,
                                  false,
                                  false,
                                  modulesIntermediairesCarton7,
                                  false,
                                  false,
                                  false);
                              verifcheck1();
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
                              modulesIntermediairesCarton8 = newbox;
                              databaseChecklists.saveCheckListCartons(
                                  'Carton8',
                                  int.parse(widget.btuid),
                                  false,
                                  false,
                                  false,
                                  modulesIntermediairesCarton8,
                                  false,
                                  false,
                                  false);
                              verifcheck1();
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
                              moduleslaterauxbackCarton9 = newbox;
                              databaseChecklists.saveCheckListCartons(
                                  'Carton9',
                                  int.parse(widget.btuid),
                                  false,
                                  false,
                                  false,
                                  false,
                                  moduleslaterauxbackCarton9,
                                  false,
                                  false);
                              verifcheck1();
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
                              moduleslaterauxfrontCarton10 = newbox;
                              databaseChecklists.saveCheckListCartons(
                                  'Carton10',
                                  int.parse(widget.btuid),
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  moduleslaterauxfrontCarton10,
                                  false);
                              verifcheck1();
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
                              calesboisCarton11 = newbox;
                              databaseChecklists.saveCheckListCartons(
                                  'Carton11',
                                  int.parse(widget.btuid),
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  calesboisCarton11);
                              verifcheck1();
                            }),
                      ],
                    );
                  }),
              FractionallySizedBox(
                child: Container(
                  height: 50,
                ),
              ),
            ],
          ),
        )));
  }
}
