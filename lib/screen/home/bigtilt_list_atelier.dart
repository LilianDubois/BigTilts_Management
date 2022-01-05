import 'dart:math';

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
import 'package:firebase_auth/firebase_auth.dart';
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

  String uid;
  String vendue;
  String nomclient;
  String subchecklist = '';

  @override
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
    var allbigtiltsbydate = [];
    var distinctIds = [];
    String date_atelier = 'Non renseignée';

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
        if (widget.page == 'todo') {
          if (bigtiltlist[i].date_exp == 'Non renseignée' ||
              bigtiltlist[i].expediee == false) {
            allbigtiltsbydate.add((bigtiltlist[i].date_exp).toString());
          }
        } else if (widget.page == 'all') {
          allbigtilts.add((bigtiltlist[i].id).toString());
        } else if (widget.page == 'shipped') {
          if (bigtiltlist[i].date_exp != 'Non renseignée' &&
              bigtiltlist[i].expediee == true &&
              bigtiltlist[i].archived == false) {
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (widget.page == 'archived') {
          if (bigtiltlist[i].archived == true) {
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        }
      }
    }

    choisir();

    if (widget.page == 'todo') {
      allbigtiltsbydate.sort((a, b) => a.compareTo(b));
      for (var c = 0; c < allbigtiltsbydate.length; c++) {
        for (var i = 0; i < bigtiltlist.length; i++) {
          if (bigtiltlist[i].date_exp == allbigtiltsbydate[c]) {
            distinctIds.add((bigtiltlist[i].id).toString());
          }
        }
      }
      allbigtilts = distinctIds.toSet().toList();
    }

    return ListView.builder(
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

          if (widget.page == 'todo') {
            //allbigtilts.sort((a, b) => a.compareTo(b));

            while (bigtiltlist[indexx].id != int.parse(allbigtilts[index])) {
              indexx++;
            }
          } else {
            while (bigtiltlist[indexx].id != int.parse(allbigtilts[index])) {
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

          bool expediee = true;
          bool emergency = false;

          switchWithString() {
            switch (currentselection.vendue) {
              case true:
                return 'Vendue';
                break;

              case false:
                return 'En stock';
                break;
            }
          }

          if (currentselection.date_exp != 'Non renseignée') {
            expediee = now.isAfter(DateTime.parse(currentselection.date_exp));
            date = DateTime.parse(currentselection.date_exp)
                .difference(now)
                .inDays;
            if (date < 8) emergency = true;
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
                                  color: expediee
                                      ? Colors.orange
                                      : emergency
                                          ? Colors.red
                                          : Colors.orange,
                                  width: 5.0,
                                )),
                            margin: EdgeInsets.only(
                                top: 12.0, bottom: 6.0, left: 10.0, right: 5.0),
                            child: ListTile(
                                title: Text(
                                  'BigTilt : ${currentselection.nomclient}',
                                  style: TextStyle(),
                                ),
                                subtitle: Text(
                                  switchWithString(),
                                  style: TextStyle(),
                                ),
                                trailing: Wrap(
                                  spacing: 12, // space between two icons
                                  children: <Widget>[
                                    Text(
                                      'N°${(currentselection.id).toString()}',
                                    ), // icon-1
                                    Icon(
                                      const IconData(58800,
                                          fontFamily: 'MaterialIcons'),
                                    ), // icon-2
                                  ],
                                ),
                                onTap: () {
                                  if (widget.stateUser == 1)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltAdmin(
                                                    currentselection.id,
                                                    currentselection.vendue,
                                                    currentselection.nomclient,
                                                    currentselection.chassit,
                                                    currentselection.materiaux,
                                                    currentselection.plancher,
                                                    currentselection
                                                        .deco_module,
                                                    currentselection.taille,
                                                    currentselection.tapis,
                                                    currentselection.tapistype,
                                                    currentselection
                                                        .pack_marketing,
                                                    currentselection
                                                        .transport_type,
                                                    currentselection
                                                        .date_atelier,
                                                    currentselection.date_exp,
                                                    currentselection.date_valid,
                                                    currentselection.videoproj,
                                                    currentselection
                                                        .videoproj_type,
                                                    currentselection.archived,
                                                    currentselection.infos,
                                                    currentselection
                                                        .expediee)));
                                  if (widget.stateUser == 2)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltAtelier(
                                                    currentselection.id,
                                                    currentselection.vendue,
                                                    currentselection.nomclient,
                                                    currentselection.chassit,
                                                    currentselection.materiaux,
                                                    currentselection.plancher,
                                                    currentselection
                                                        .deco_module,
                                                    currentselection.taille,
                                                    currentselection.tapis,
                                                    currentselection.tapistype,
                                                    currentselection
                                                        .pack_marketing,
                                                    currentselection
                                                        .transport_type,
                                                    currentselection
                                                        .date_atelier,
                                                    currentselection.date_exp,
                                                    currentselection.date_valid,
                                                    currentselection.videoproj,
                                                    currentselection
                                                        .videoproj_type,
                                                    currentselection.archived,
                                                    currentselection.infos,
                                                    currentselection
                                                        .expediee)));
                                  if (widget.stateUser == 3)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltCommerciaux(
                                                    currentselection.id,
                                                    currentselection.vendue,
                                                    currentselection.nomclient,
                                                    currentselection.chassit,
                                                    currentselection.materiaux,
                                                    currentselection.plancher,
                                                    currentselection
                                                        .deco_module,
                                                    currentselection.taille,
                                                    currentselection.tapis,
                                                    currentselection.tapistype,
                                                    currentselection
                                                        .pack_marketing,
                                                    currentselection
                                                        .transport_type,
                                                    currentselection
                                                        .date_atelier,
                                                    currentselection.date_exp,
                                                    currentselection.date_valid,
                                                    currentselection.videoproj,
                                                    currentselection
                                                        .videoproj_type,
                                                    currentselection.archived,
                                                    currentselection.infos,
                                                    currentselection
                                                        .expediee)));
                                  if (widget.stateUser == 4)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltDev(
                                                    currentselection.id,
                                                    currentselection.vendue,
                                                    currentselection.nomclient,
                                                    currentselection.chassit,
                                                    currentselection.materiaux,
                                                    currentselection.plancher,
                                                    currentselection
                                                        .deco_module,
                                                    currentselection.taille,
                                                    currentselection.tapis,
                                                    currentselection.tapistype,
                                                    currentselection
                                                        .pack_marketing,
                                                    currentselection
                                                        .transport_type,
                                                    currentselection
                                                        .date_atelier,
                                                    currentselection.date_exp,
                                                    currentselection.date_valid,
                                                    currentselection.videoproj,
                                                    currentselection
                                                        .videoproj_type,
                                                    currentselection.archived,
                                                    currentselection.infos,
                                                    currentselection
                                                        .expediee)));
                                }),
                          ),
                          if (currentselection.date_exp != 'Non renseignée' &&
                              widget.page == 'todo')
                            Text(
                              date < 0
                                  ? 'Expédition imminente'
                                  : 'Date d\'expedition dans $date jours',
                              style: TextStyle(
                                color: emergency ? Colors.red : Colors.orange,
                              ),
                            ),
                        ],
                      ),
                    ),
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
                          margin:
                              EdgeInsets.only(top: 12.0, bottom: 6.0, right: 5),
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
                                          builder: (BuildContext context) =>
                                              CreateCheckList(
                                                  currentselection.id
                                                      .toString(),
                                                  currentselection.taille)));
                                } else
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CheckList(currentselection.id
                                                  .toString())));
                              }),
                        ),
                        if (currentselection.date_exp != 'Non renseignée' &&
                            widget.page == 'todo')
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
                if (date < 0 && widget.page == 'todo')
                  FlatButton(
                    child: Text(
                      'Confirmer l\'expédition',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.green,
                            width: 5,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50)),
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      bigtiltInstance
                          .doc(currentselection.id.toString())
                          .update({"expediee": true});
                      databaselogs.saveLogs(
                          '${DateTime.now().toString()}',
                          user.name,
                          'a confirmé l\'expédition de la BigTilt ${currentselection.id}',
                          DateTime.now().toString(),
                          currentselection.id.toString());
                    },
                  )
              ],
            ),
          );
        });
  }
}
