import 'dart:convert';
import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/user.dart';

import 'package:bigtitlss_management/screen/admin/udpate_bigtilt_admin.dart';
import 'package:bigtitlss_management/screen/atelier/update_bigtilt_atelier.dart';
import 'package:bigtitlss_management/screen/commerciaux/udpate_bigtilt_Commerciaux.dart';
import 'package:bigtitlss_management/screen/dev/udpate_bigtilt_dev.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BigtiltsList extends StatefulWidget {
  var stateUser;
  var page;
  BigtiltsList(this.stateUser, this.page);
  @override
  _BigtiltsListState createState() => _BigtiltsListState();
}

class _BigtiltsListState extends State<BigtiltsList> {
  int cupertinoTabBarIValue = 0;
  int cupertinoTabBarIValueGetter() => cupertinoTabBarIValue;

  void initState() {
    // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // // firebase messaging on receiving from the push notifications start - Naveen
    // FirebaseMessaging.onBackgroundMessage((message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   print(message);
    // });
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
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final bigtiltsInstance = FirebaseFirestore.instance.collection("bigtilts");
    final database = DatabaseBigtilts();
    final databaselogs = DatabaseLogs();

    AppUserData user;

    var now = DateTime.now();

    int date;
    List _items = [];

    var previousid;

    var allbigtilts = [];
    var allbigtiltsFR = [];
    var allbigtiltsUS = [];
    var allbigtiltsbydate = [];
    var distinctIds = [];

    String date_atelier;
    String numberUS;
    String numberFR;

    Future<void> logsaving(String item, String id) async {
      databaselogs.saveLogs(
          '${DateTime.now().toString()}',
          user.name,
          'a chang?? l\'??tat de la bigtilt $id ?? $item',
          DateTime.now().toString(),
          id.toString());
    }

    void _showCupertinoDialog(int id) {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Nouveau statut pour la BigTilt ${id.toString()}'),
              content: Text('Selectionner son nouveau statut'),
              actions: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            logsaving('R??serv??e', id.toString());
                            bigtiltsInstance
                                .doc(id.toString())
                                .update({"status": "R??serv??e"});
                            Navigator.pop(context);
                          },
                          child: Text('R??serv??e')),
                      TextButton(
                        onPressed: () {
                          logsaving('En stock FR', id.toString());
                          bigtiltsInstance
                              .doc(id.toString())
                              .update({"status": "En stock FR"});
                          Navigator.pop(context);
                        },
                        child: Text('En stock FR'),
                      ),
                      TextButton(
                        onPressed: () {
                          logsaving('En stock US', id.toString());
                          bigtiltsInstance
                              .doc(id.toString())
                              .update({"status": "En stock US"});
                          Navigator.pop(context);
                        },
                        child: Text('En stock US'),
                      ),
                      TextButton(
                        onPressed: () {
                          logsaving('Vendue', id.toString());
                          bigtiltsInstance
                              .doc(id.toString())
                              .update({"status": "Vendue"});
                          Navigator.pop(context);
                        },
                        child: Text('Vendue'),
                      ),
                      TextButton(
                        onPressed: () {
                          logsaving('Exp??di??e', id.toString());
                          bigtiltsInstance
                              .doc(id.toString())
                              .update({"status": "Exp??di??e"});
                          Navigator.pop(context);
                        },
                        child: Text('Exp??di??e'),
                      ),
                      TextButton(
                        onPressed: () {
                          logsaving('Livr??e', id.toString());
                          bigtiltsInstance
                              .doc(id.toString())
                              .update({"status": "Livr??e"});
                          Navigator.pop(context);
                        },
                        child: Text('Livr??e'),
                      )
                    ])
              ],
            );
          });
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Attention'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Cette bigtilt n\est pas encore disponible vous y aurez acc??s une fois qu\'elle sera disponible'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void choisir() {
      for (var i = 0; i < bigtiltlist.length; i++) {
        if (widget.page == 'available') {
          if (bigtiltlist[i].status == 'En stock FR') {
            allbigtiltsFR.add((bigtiltlist[i].id).toString());
            setState(() {
              numberFR = allbigtiltsFR.length.toString();
            });
          }
          if (bigtiltlist[i].status == 'En stock US') {
            allbigtiltsUS.add((bigtiltlist[i].id).toString());
            setState(() {
              numberUS = allbigtiltsUS.length.toString();
            });
            if (numberUS == null) numberUS = '0';
          }
          if (cupertinoTabBarIValue == 0) {
            if (bigtiltlist[i].status == 'En stock FR') {
              //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
              allbigtilts.add((bigtiltlist[i].id).toString());
            }
          } else {
            if (bigtiltlist[i].status == 'En stock US') {
              //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
              allbigtilts.add((bigtiltlist[i].id).toString());
            }
          }
        } else if (widget.page == 'reserved') {
          if (bigtiltlist[i].status == 'R??serv??e') {
            //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (widget.page == 'sold') {
          if (bigtiltlist[i].status == 'Vendue') {
            allbigtiltsFR.add((bigtiltlist[i].id).toString());
            setState(() {
              numberFR = allbigtiltsFR.length.toString();
            });
          }
          if (bigtiltlist[i].status == 'Vendue US') {
            allbigtiltsUS.add((bigtiltlist[i].id).toString());
            setState(() {
              numberUS = allbigtiltsUS.length.toString();
            });
          }
          if (cupertinoTabBarIValue == 0) {
            if (bigtiltlist[i].status == 'Vendue') {
              //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
              allbigtiltsbydate.add((bigtiltlist[i].date_exp).toString());
              print(allbigtiltsbydate);
            }
          } else {
            if (bigtiltlist[i].status == 'Vendue US') {
              //now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))
              allbigtiltsbydate.add((bigtiltlist[i].date_exp).toString());
            }
          }
        } else if (widget.page == 'all') {
          allbigtilts.add((bigtiltlist[i].id).toString());
        } else if (widget.page == 'dispatched') {
          if (bigtiltlist[i].status == 'Expedi??e' ||
              bigtiltlist[i].status == 'Exp??di??e') {
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (bigtiltlist[i].status == 'En place chez le client' ||
            bigtiltlist[i].status == 'Livr??e') {
          allbigtilts.add((bigtiltlist[i].id).toString());
        }
      }
    }

    choisir();

    if (widget.page == 'sold') {
      allbigtiltsbydate.sort((a, b) => a.compareTo(b));
      for (var c = 0; c < allbigtiltsbydate.length; c++) {
        for (var i = 0; i < bigtiltlist.length; i++) {
          if (bigtiltlist[i].status == 'Vendue' ||
              bigtiltlist[i].status == 'Vendue US') {
            if (bigtiltlist[i].date_exp == allbigtiltsbydate[c]) {
              distinctIds.add((bigtiltlist[i].id).toString());
            }
          }
        }
      }
      allbigtilts = distinctIds.toSet().toList();
    }

    print(allbigtilts);
    print(allbigtiltsbydate);

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    user = users[index];

    return Column(children: <Widget>[
      if (widget.page == 'available' || widget.page == 'sold')
        SizedBox(height: 20),
      if (widget.page == 'sold') Text('Bigtilt au d??part de '),
      if (widget.page == 'available' || widget.page == 'sold')
        CupertinoTabBar.CupertinoTabBar(
          darkmode ? Color(0xFF1c1b20) : Color(0xFFd4d7dd),
          darkmode ? Color(0xFF5b5a61) : Color(0xFFf7f7f7),
          [
            Text(
              widget.page == 'available'
                  ? "Stock FR ???????? (${numberFR == null ? '0' : numberFR})"
                  : "France ???????? (${numberFR == null ? '0' : numberFR})",
              style: TextStyle(
                color: darkmode ? Colors.white : Colors.black,
                fontSize: 18.75,
                fontWeight: FontWeight.w400,
                fontFamily: "SFProRounded",
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.page == 'available'
                  ? "Stock US ???????? (${numberUS == null ? '0' : numberUS})"
                  : "USA ???????? (${numberUS == null ? '0' : numberUS})",
              style: TextStyle(
                color: darkmode ? Colors.white : Colors.black,
                fontSize: 18.75,
                fontWeight: FontWeight.w400,
                fontFamily: "SFProRounded",
              ),
              textAlign: TextAlign.center,
            ),
          ],
          cupertinoTabBarIValueGetter,
          (int index) {
            setState(() {
              cupertinoTabBarIValue = index;
            });
          },
          useShadow: true,
          innerHorizontalPadding: 10,
          useSeparators: true,
        ),
      Expanded(
        child: ListView.builder(
            itemCount: allbigtilts.length,
            itemBuilder: (context, index) {
              AppBigTiltsData currentselection;
              var indexx = 0;

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

              bool expediee = true;
              bool emergency = false;
              bool disponible = false;

              if (currentselection.date_exp != 'Non renseign??e') {
                expediee =
                    now.isAfter(DateTime.parse(currentselection.date_exp));
                date = DateTime.parse(currentselection.date_exp)
                    .difference(now.subtract(Duration(days: 1)))
                    .inDays;
                if (date < 8 || date <= 0) emergency = true;
              }
              if (currentselection.date_atelier != 'Non renseign??e') {
                if (DateTime.parse(currentselection.date_atelier)
                    .isAfter(now)) {
                  disponible = true;
                } else {
                  disponible = false;
                }
              }

              if (currentselection.id == 1) {
                database.saveBigtilt(
                  currentselection.id,
                  currentselection.nomclient,
                  currentselection.chassit,
                  currentselection.materiaux,
                  currentselection.deco_module,
                  currentselection.plancher,
                  currentselection.taille,
                  currentselection.tapis,
                  currentselection.tapistype,
                  currentselection.pack_marketing,
                  currentselection.date_atelier,
                  currentselection.date_exp,
                  currentselection.date_valid,
                  currentselection.transport_type,
                  currentselection.videoproj,
                  currentselection.videoproj_type,
                  currentselection.version,
                  currentselection.infos,
                  currentselection.countrycode,
                  currentselection.status,
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: <Widget>[
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: disponible
                                  ? Colors.grey
                                  : expediee
                                      ? Colors.orange
                                      : emergency
                                          ? Colors.red
                                          : Colors.orange,
                              width: 5.0,
                            )),
                        margin: EdgeInsets.only(
                            top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                '${currentselection.nomclient} ?? ${currentselection.taille.substring(0, 1)}m',
                                style: TextStyle(),
                              ),
                              subtitle: Text(currentselection.status),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  Text(
                                    'N??${(currentselection.id).toString()}',
                                  ), // icon-1
                                  Icon(
                                    const IconData(58800,
                                        fontFamily: 'MaterialIcons'),
                                  ), // icon-2
                                ],
                              ),
                              onTap: () {
                                if (disponible) {
                                  _showMyDialog();
                                } else {
                                  if (widget.stateUser == 1)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltAdmin(
                                                  currentselection.id,
                                                )));
                                  if (widget.stateUser == 2)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltAtelier(
                                                  currentselection.id,
                                                )));
                                  if (widget.stateUser == 3)
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateBigtiltCommerciaux(
                                                  currentselection.id,
                                                )));
                                  //if (widget.stateUser == 4)
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             UpdateBigtiltDev(
                                  //                 currentselection.id,
                                  //                 currentselection.vendue,
                                  //                 currentselection.nomclient,
                                  //                 currentselection.chassit,
                                  //                 currentselection.materiaux,
                                  //                 currentselection.plancher,
                                  //                 currentselection.deco_module,
                                  //                 currentselection.taille,
                                  //                 currentselection.tapis,
                                  //                 currentselection.tapistype,
                                  //                 currentselection.pack_marketing,
                                  //                 currentselection.transport_type,
                                  //                 currentselection.date_atelier,
                                  //                 currentselection.date_exp,
                                  //                 currentselection.date_valid,
                                  //                 currentselection.videoproj,
                                  //                 currentselection.videoproj_type,
                                  //                 currentselection.archived,
                                  //                 currentselection.infos,
                                  //                 currentselection.expediee,
                                  //                 currentselection.status)
                                  //                 ));
                                }
                              },
                              onLongPress: () {
                                disponible
                                    ? ""
                                    : _showCupertinoDialog(currentselection.id);
                              },
                            ),
                            if (widget.page == 'sold' ||
                                widget.page == 'reserved')
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tapis : ' + currentselection.tapistype,
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 6),
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
                                            child:
                                                Text(currentselection.infos)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                          ],
                        )),
                    if (currentselection.date_exp != 'Non renseign??e' &&
                        widget.page == 'sold')
                      Text(
                        date <= 0
                            ? 'Exp??dition imminente'
                            : 'Date d\'expedition dans $date jours',
                        style: TextStyle(
                          color: emergency ? Colors.red : Colors.orange,
                        ),
                      ),
                    if (currentselection.date_atelier != 'Non renseign??e' &&
                        DateTime.parse(currentselection.date_atelier)
                            .isAfter(now) &&
                        widget.page == 'available')
                      Text(
                        'Disponible a partir du ${DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(currentselection.date_atelier))}',
                        style: TextStyle(
                          color: emergency ? Colors.red : Colors.orange,
                        ),
                      ),
                  ],
                ),
              );
            }),
      ),
    ]);
  }
}
