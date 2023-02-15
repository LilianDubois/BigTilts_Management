import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/checkLists.dart';
import 'package:bigtitlss_management/models/user.dart';

import 'package:bigtitlss_management/screen/admin/udpate_bigtilt_admin.dart';
import 'package:bigtitlss_management/screen/atelier/CheckList/CheckList.dart';
import 'package:bigtitlss_management/screen/atelier/CheckList/create_checkList.dart';
import 'package:bigtitlss_management/screen/atelier/update_bigtilt_atelier.dart';
import 'package:bigtitlss_management/screen/commerciaux/udpate_bigtilt_Commerciaux.dart';
import 'package:bigtitlss_management/screen/dev/udpate_bigtilt_dev.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BigtiltsListAtelier extends StatefulWidget {
  var stateUser;
  var page;
  BigtiltsListAtelier(this.stateUser, this.page);
  @override
  _BigtiltsListStateAtelier createState() => _BigtiltsListStateAtelier();
}

class _BigtiltsListStateAtelier extends State<BigtiltsListAtelier> {
  final firestoreInstance = FirebaseFirestore.instance;

  int cupertinoTabBarIValue = 0;
  int cupertinoTabBarIValueGetter() => cupertinoTabBarIValue;

  String uid;
  String vendue;
  String nomclient;
  String subchecklist = '';

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
  bool darkmode = false;
  dynamic savedThemeMode;

  Widget build(BuildContext context) {
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final bigtiltInstance = FirebaseFirestore.instance.collection("bigtilts");
    final checkListlist = Provider.of<List<AppCheckListsData>>(context);
    final database = DatabaseBigtilts();
    final databaselogs = DatabaseLogs();

    var now = DateTime.now();

    int date;

    var previousid;

    var allbigtilts = [];
    var allbigtiltsFR = [];
    var allbigtiltsUS = [];
    var allbigtiltsbydate = [];
    var distinctIds = [];
    String date_atelier = 'Non renseignée';
    String numberUS;
    String numberFR;

    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    AppUserData user;

    var indexusers = 0;
    while (users[indexusers].uid != firebaseUser.uid) {
      indexusers++;
    }
    user = users[indexusers];

    void choisir() {
      for (var i = 0; i < bigtiltlist.length; i++) {
        if (widget.page == 'available') {
          if (bigtiltlist[i].status == 'En stock FR') {
            //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (widget.page == 'reserved') {
          if (bigtiltlist[i].status == 'Réservée') {
            //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (widget.page == 'sold') {
          if (bigtiltlist[i].status == 'Vendue') {
            //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
            allbigtiltsbydate.add((bigtiltlist[i].date_exp).toString());
          }
        } else if (widget.page == 'all') {
          allbigtilts.add((bigtiltlist[i].id).toString());
        } else if (widget.page == 'dispatched') {
          if (bigtiltlist[i].status == 'Expediée' ||
              bigtiltlist[i].status == 'Expédiée') {
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (bigtiltlist[i].status == 'En place chez le client' ||
            bigtiltlist[i].status == 'Livrée') {
          allbigtilts.add((bigtiltlist[i].id).toString());
        }
      }
    }

    choisir();

    if (widget.page == 'sold') {
      allbigtiltsbydate.sort((a, b) => a.compareTo(b));
      for (var c = 0; c < allbigtiltsbydate.length; c++) {
        for (var i = 0; i < bigtiltlist.length; i++) {
          if (bigtiltlist[i].status == 'Vendue') {
            if (bigtiltlist[i].date_exp == allbigtiltsbydate[c]) {
              distinctIds.add((bigtiltlist[i].id).toString());
            }
          }
        }
      }
      allbigtilts = distinctIds.toSet().toList();
    }

    return Column(children: <Widget>[
      // if (widget.page == 'available') SizedBox(height: 20),
      // if (widget.page == 'available')
      //   CupertinoTabBar.CupertinoTabBar(
      //     darkmode ? Color(0xFF1c1b20) : Color(0xFFd4d7dd),
      //     darkmode ? Color(0xFF5b5a61) : Color(0xFFf7f7f7),
      //     [
      //       Text(
      //         "Stock FR 🇫🇷 ($numberFR)",
      //         style: TextStyle(
      //           color: darkmode ? Colors.white : Colors.black,
      //           fontSize: 18.75,
      //           fontWeight: FontWeight.w400,
      //           fontFamily: "SFProRounded",
      //         ),
      //         textAlign: TextAlign.center,
      //       ),
      //       Text(
      //         "Stock US 🇺🇸 ($numberUS)",
      //         style: TextStyle(
      //           color: darkmode ? Colors.white : Colors.black,
      //           fontSize: 18.75,
      //           fontWeight: FontWeight.w400,
      //           fontFamily: "SFProRounded",
      //         ),
      //         textAlign: TextAlign.center,
      //       ),
      //     ],
      //     cupertinoTabBarIValueGetter,
      //     (int index) {
      //       setState(() {
      //         cupertinoTabBarIValue = index;
      //       });
      //     },
      //     useShadow: true,
      //     innerHorizontalPadding: 10,
      //     useSeparators: true,
      //   ),
      Expanded(
          child: ListView.builder(
              itemCount: allbigtilts.length,
              itemBuilder: (context, index) {
                AppBigTiltsData currentselection;
                AppCheckListsData currentCheckList;
                var indexx = 0;
                var indexxCheckList = 0;
                bool checklist = false;
                bool check2 = false;
                bool check1 = false;

                var idd;
                var previousid;

                if (widget.page == 'sold' ||
                    widget.page == 'available' ||
                    widget.page == 'reserved') {
                  //allbigtilts.sort((a, b) => a.compareTo(b));

                  while (
                      bigtiltlist[indexx].id != int.parse(allbigtilts[index])) {
                    indexx++;
                  }
                } else {
                  while (
                      bigtiltlist[indexx].id != int.parse(allbigtilts[index])) {
                    indexx++;
                  }
                }

                currentselection = bigtiltlist[indexx];

                if (currentselection.id == checkListlist[indexxCheckList].id)
                  currentCheckList = checkListlist[indexxCheckList];
                else
                  indexxCheckList++;

                for (var i = 0; i < checkListlist.length; i++) {
                  if (currentselection.id == checkListlist[i].id) {
                    currentCheckList = checkListlist[i];
                    check2 = currentCheckList.check2;
                    check1 = currentCheckList.check1;
                    checklist = true;
                  }
                }

                bool expediee = false;
                bool emergency = false;

                if (currentselection.date_exp != 'Non renseignée') {
                  expediee =
                      now.isAfter(DateTime.parse(currentselection.date_exp));
                  date = DateTime.parse(currentselection.date_exp)
                      .difference(now.subtract(Duration(days: 1)))
                      .inDays;
                  if (date < 8 || date <= 0) emergency = true;
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color:
                                            currentselection.status != 'Vendue'
                                                ? Colors.orange
                                                : emergency
                                                    ? Colors.red
                                                    : Colors.orange,
                                        width: 5.0,
                                      )),
                                  margin: EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 6.0,
                                      left: 10.0,
                                      right: 5.0),
                                  child: Column(children: [
                                    ListTile(
                                        title: Text(
                                          '${currentselection.nomclient} · ${currentselection.taille.substring(0, 1)}m',
                                          style: TextStyle(),
                                        ),
                                        subtitle: Text(currentselection.status),
                                        trailing: Wrap(
                                          spacing:
                                              12, // space between two icons
                                          children: <Widget>[
                                            Text(
                                              'N°${(currentselection.id).toString()}',
                                            ), // icon-1
                                            Icon(
<<<<<<< Updated upstream
                                              const IconData(58800,
                                                  fontFamily: 'MaterialIcons'),
                                            ), // icon-2
=======
                                              Icons.chevron_right,
                                              color: darkmode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
>>>>>>> Stashed changes
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          UpdateBigtiltAtelier(
                                                            currentselection.id,
                                                          )));
                                        }),
                                    if (widget.page == 'sold' ||
                                        widget.page == 'reserved')
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Tapis : ' +
                                                  currentselection.tapistype,
                                              textAlign: TextAlign.left,
                                            ),
                                            Text('Destination : ' +
                                                currentselection.countrycode),
                                          ],
                                        ),
                                      ),
                                    if (currentselection.infos != "" &&
                                        (widget.page == 'sold' ||
                                            widget.page == 'reserved'))
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 6),
                                              child: Divider(
                                                height: 10,
                                                thickness: 3,
                                                color: darkmode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text('infos : '),
                                                Flexible(
                                                    child: Text(currentselection
                                                        .infos)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                  ]),
                                ),
                                if (currentselection.date_exp !=
                                        'Non renseignée' &&
                                    widget.page == 'sold')
                                  Text(
                                    date <= 0
                                        ? 'Expédition imminente'
                                        : 'Expedition dans $date jours',
                                    style: TextStyle(
                                      color: emergency
                                          ? Colors.red
                                          : Colors.orange,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          //if (widget.page != 'all')
                          Expanded(
                            flex: 3,
                            child: Column(children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: check2 && check1
                                          ? Colors.green
                                          : Colors.orange,
                                      width: 5.0,
                                    )),
                                margin: EdgeInsets.only(
                                    top: 12.0, bottom: 6.0, right: 5),
                                child: Padding(
                                  padding: checklist
                                      ? const EdgeInsets.fromLTRB(0, 5, 0, 5)
                                      : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ListTile(
                                      title: Text(
                                        'Check List',
                                        style: TextStyle(),
                                      ),
                                      subtitle: Text(
                                        checklist
                                            ? 'Emplacement : ${currentCheckList.palette.toString()}'
                                            : 'A Créer',
                                        style: TextStyle(),
                                      ),
                                      onTap: () async {
                                        final snapshot = await firestoreInstance
                                            .collection('checkLists')
                                            .doc(currentselection.id.toString())
                                            .get();
                                        if (!snapshot.exists) {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      CreateCheckList(
                                                          currentselection.id
                                                              .toString(),
                                                          currentselection
                                                              .taille)));
                                        } else
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      CheckList(currentselection
                                                          .id
                                                          .toString())));
                                      }),
                                ),
                              ),
                              if (currentselection.date_exp !=
                                      'Non renseignée' &&
                                  widget.page == 'sold')
                                Text(
                                  check1
                                      ? check2
                                          ? ' '
                                          : '2eme Check'
                                      : ' ',
                                  style: TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                            ]),
                          ),
                        ],
                      ),
                      if (currentselection.date_exp != 'Non renseignée' &&
                          date <= 0 &&
                          widget.page == 'sold')
                        check2
                            ? TextButton(
                                child: Text(
                                  'Confirmer l\'expédition',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.green,
                                            width: 5,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    padding: EdgeInsets.all(10)),
                                onPressed: () {
                                  bigtiltInstance
                                      .doc(currentselection.id.toString())
                                      .update({"status": 'Expédiée'});
                                  databaselogs.saveLogs(
                                      '${DateTime.now().toString()}',
                                      user.name,
                                      'a confirmé l\'expédition de la BigTilt ${currentselection.id}',
                                      DateTime.now().toString(),
                                      currentselection.id.toString());
                                },
                              )
                            : Column(children: [
                                SizedBox(height: 10),
                                Text(
                                  'Attention la check list n\'est pas complète',
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(
                                  'Vous ne pourrez donc pas valider l\'expédition',
                                  style: TextStyle(color: Colors.red),
                                )
                              ])
                    ],
                  ),
                );
              }))
    ]);
  }
}
