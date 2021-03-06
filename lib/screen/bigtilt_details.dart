import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigtiltDetails extends StatefulWidget {
  var Uid;
  BigtiltDetails(this.Uid);

  @override
  _BigtiltDetailsState createState() => _BigtiltDetailsState();
}

class _BigtiltDetailsState extends State<BigtiltDetails> {
  final databaselogs = DatabaseLogs();

  void initState() {
    super.initState();
    getCurrentTheme();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
        colorBorder = Colors.white;
      });
    } else {
      setState(() {
        darkmode = false;
        colorBorder = Colors.black;
      });
    }
  }

  @override
  bool darkmode = false;
  dynamic savedThemeMode;
  Color colorBorder;
  String _selectedTapissub;
  String majControllerval;

  static final List<String> flowerItems = <String>[
    '-',
    '0.1',
    '0.2',
  ];

  static final List<String> materiauxitems = <String>[
    '-',
    'MDF',
    'PLA',
  ];

  static final List<String> plancheritems = <String>[
    '-',
    'Forex',
    'Aglo22',
  ];

  static final List<String> decoItems = <String>[
    '-',
    'Classique',
    'Custom',
  ];

  static final List<String> videotypeitems = <String>[
    '-',
    'Android TV',
    'Android',
    'MI UITV',
  ];

  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final bigtiltsInstance = FirebaseFirestore.instance.collection("bigtilts");
    AppBigTiltsData bigtilt;
    AppUserData user;
    final majController = TextEditingController(text: majControllerval);

    var index = 0;
    while (bigtiltlist[index].id != widget.Uid) {
      index++;
    }
    bigtilt = bigtiltlist[index];

    var indexuser = 0;
    while (users[indexuser].uid != firebaseUser.uid) {
      indexuser++;
    }
    user = users[indexuser];

    if (majController.text != "") {
      majControllerval = majController.text;
    } else {
      majControllerval = bigtilt.version.toString();
    }

    Future<void> logsaving(String item) async {
      databaselogs.saveLogs(
          '${DateTime.now().toString()}',
          user.name,
          'a modifi?? la bigtilt ${widget.Uid.toString()} ($item)',
          DateTime.now().toString(),
          widget.Uid.toString());
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
                      'Seul les personnes de l\'atelier peuvent modifier ses vaeurs'),
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Bigtilt N??${widget.Uid}'),
          elevation: 0.0,
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: [
          SizedBox(height: 20.0),
          Text('d??tails technique BigTilt ${bigtilt.id}'),
          SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(color: colorBorder, width: 4)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Type de chassis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        // isExpanded: true,

                        value: bigtilt.chassit,
                        onChanged: (value) {
                          print(user.state);
                          if (user.state == 2 || user.state == 1) {
                            logsaving('Chassit');
                            bigtiltsInstance
                                .doc(bigtilt.id.toString())
                                .update({"Chassit": value});
                          } else
                            _showMyDialog();
                        },
                        items: flowerItems
                            .map((item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  value: item,
                                ))
                            .toList(),
                      ),
                    ),
                  ]),
            ),
          ),
          FractionallySizedBox(
            child: Container(
              height: 20,
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(color: colorBorder, width: 4)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mat??riaux modules',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        // isExpanded: true,

                        value: bigtilt.materiaux,
                        onChanged: (value) {
                          print(user.state);
                          if (user.state == 2 || user.state == 1) {
                            logsaving('Mat??riaux modules');
                            bigtiltsInstance
                                .doc(bigtilt.id.toString())
                                .update({"Materiaux": value});
                          } else
                            _showMyDialog();
                        },

                        items: materiauxitems
                            .map((item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  value: item,
                                ))
                            .toList(),
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(color: colorBorder, width: 4)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plancher',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        // isExpanded: true,

                        value: bigtilt.plancher,
                        onChanged: (value) {
                          print(user.state);
                          if (user.state == 2 || user.state == 1) {
                            logsaving('Plancher');
                            bigtiltsInstance
                                .doc(bigtilt.id.toString())
                                .update({"plancher": value});
                          } else
                            _showMyDialog();
                        },

                        items: plancheritems
                            .map((item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  value: item,
                                ))
                            .toList(),
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(color: colorBorder, width: 4)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'D??coration modules',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        // isExpanded: true,

                        value: bigtilt.deco_module,
                        onChanged: (value) {
                          logsaving('D??corations modules');
                          bigtiltsInstance
                              .doc(bigtilt.id.toString())
                              .update({"deco_module": value});
                        },
                        items: decoItems
                            .map((item) => DropdownMenuItem(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  value: item,
                                ))
                            .toList(),
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 90,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(
                      color: darkmode ? Colors.white : Colors.black, width: 4)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Version du logiciel :'),
                        FlatButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 500,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                                'Enter le nouveau num??ro de version du logiciel'),
                                            SizedBox(height: 30),
                                            Flexible(
                                                child: Container(
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: majController,
                                                decoration: InputDecoration(
                                                  hintText: 'Version',
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (value) {
                                                  majControllerval = value;
                                                },
                                              ),
                                            )),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  child: const Text('Annuler'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                    child:
                                                        const Text('Valider'),
                                                    onPressed: () {
                                                      logsaving('version');
                                                      bigtiltsInstance
                                                          .doc(bigtilt.id
                                                              .toString())
                                                          .update({
                                                        "version":
                                                            majControllerval
                                                      });
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text("Modifier",
                                style: TextStyle(color: Colors.blue)))
                      ],
                    ),
                    Text(
                      '${bigtilt.version}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius:
                    new BorderRadius.vertical(top: Radius.circular(10)),
                border: Border.all(color: colorBorder, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vid??o projecteur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Switch(
                      activeColor: Colors.white,
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey,
                      value: bigtilt.videoproj,
                      onChanged: (value) {
                        logsaving('Vid??o projecteur');
                        bigtiltsInstance
                            .doc(bigtilt.id.toString())
                            .update({"videoproj": value});
                      },
                    )
                  ]),
            ),
          ),
          if (bigtilt.videoproj)
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: new BoxDecoration(
                  borderRadius:
                      new BorderRadius.vertical(bottom: Radius.circular(10)),
                  border: Border.all(color: colorBorder, width: 4),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          // isExpanded: true,

                          value: bigtilt.videoproj_type,
                          onChanged: (value) {
                            if (user.state == 2 || user.state == 1) {
                              logsaving('Vid??o proj Type');
                              bigtiltsInstance
                                  .doc(bigtilt.id.toString())
                                  .update({"videoproj_type": value});
                            } else
                              _showMyDialog();
                          },

                          items: videotypeitems
                              .map((item) => DropdownMenuItem(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    value: item,
                                  ))
                              .toList(),
                        ),
                      ),
                    ]),
              ),
            ),
        ]))));
  }
}
