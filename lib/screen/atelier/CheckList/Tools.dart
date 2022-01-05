import 'package:bigtitlss_management/Services/database_checkList.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/atelier/CheckList/CheckList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToolsScreen extends StatefulWidget {
  var btuid;
  var taillebt;
  var cartons;
  ToolsScreen(this.btuid, this.taillebt, this.cartons);

  @override
  _ToolsScreenState createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  bool _5m = false;
  bool _4m = false;
  bool _3m = false;

  List<String> stringslist;

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUserData>>(context);
    var firebaseUser = FirebaseAuth.instance.currentUser;

    AppUserData user;

    var indexuser = 0;
    while (users[indexuser].uid != firebaseUser.uid) {
      indexuser++;
    }
    user = users[indexuser];

    if (widget.taillebt == 5) {
      _5m = true;
      stringslist = [
        ' 12 Boulons M14 25mm',
        '12 Ecrous M14',
        '1 Clé tube 22',
        '1Clé plate 22',
        '16 Boulons M10 30mm',
        '16 Ecrous M10',
        '1 Clé tube 17',
        '1Clé plate 17',
        '112 Boulons M10 60mm (2 bags)',
        '112 Ecrous M10',
        '18 Boulons M10 30mm',
        '18 Rondelles M14 30mm',
        '18 Plaques acier',
        '8 Bogeys',
        '16 vis M4 16mm',
        '1 Tournevis cruciforme',
        '4 vis M8',
        '1 Clé allen 5mm',
        '1 Niveau Laser',
        '1 Clé plate 14-15',
        '4 Carrés noirs ',
        '7 Marques balle',
        'Mètre',
        'Spare Bag',
        '50 Clamps',
        '2 Paires de gants',
        'Rangement telecommande',
        'Cable alimentation adapté',
      ];
    } else if (widget.taillebt == 3) {
      _4m = true;
      stringslist = [
        '6 Boulons M14 25mm',
        '6 Ecrous M14',
        '1 Clé tube 22',
        '1 Clé plate 22',
        '8 Boulons M10 30mm',
        '8 Ecrous M10',
        '1 Clé tube 17',
        '1 Clé plate 17',
        '80 Boulons M10 60mm (2 bags)',
        '80 Ecrous M10',
        '12 Boulons M10 30mm',
        '12 Rondelles M14 30mm',
        '12 Plaques acier',
        '6 Bogeys',
        '12 vis M4 16mm',
        '1 Tournevis cruciforme',
        '4 vis M8',
        '1 Clé allen 5mm',
        '1 Niveau Laser',
        '1 Clé plate 14-15',
        '4 Carrés noirs ',
        '7 Marques balle',
        'Mètre',
        'Spare Bag',
        '30 Clamps',
        '2 Paires de gants',
        'Rangement telecommande',
        'Cable alimentation adapté',
      ];
    } else if (widget.taillebt == 4) {
      _3m = true;
      stringslist = [
        ' 9 Boulons M14 25mm',
        '9 Ecrous M14',
        '1 Clé tube 22',
        '1 Clé plate 22',
        '12 Boulons M10 30mm',
        '12 Ecrous M10',
        '1 Clé tube 17',
        '1 Clé plate 17',
        '96 Boulons M10 60mm (2 bags)',
        '96 Ecrous M10',
        '15 Boulons M10 30mm',
        '15 Rondelles M14 30mm',
        '15 Plaques acier',
        '8 Bogeys',
        '16 vis M4 16mm',
        '1 Tournevis cruciforme',
        '4 vis M8',
        '1 Clé allen 5mm',
        '1 Niveau Laser',
        '1 Clé plate 14-15',
        '4 Carrés noirs ',
        '7 Marques balle',
        'Mètre',
        'Spare Bag',
        '50 Clamps',
        '2 Paires de gants',
        'Rangement telecommande',
        'Cable alimentation adapté',
      ];
    }

    final checkListInstanceDetail = FirebaseFirestore.instance
        .collection("checkLists")
        .doc(widget.btuid)
        .collection('Checklist' + widget.btuid);
    final checkListInstance =
        FirebaseFirestore.instance.collection("checkLists");
    final databaseChecklists = DatabaseCheckLists();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Text('Tools'),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CheckList(widget.btuid)));
            },
          ),
        ),
        body: Container(
          child: StreamBuilder(
              stream: checkListInstanceDetail.doc('Carton12').snapshots(),
              builder: (context, snapshot) {
                var document = snapshot.data;
                bool _12boulonsM1425mm = document["12boulonsM1425mm"];
                bool _12ecrousM14 = document["12ecrousM14"];
                bool _1cletube22 = document["1cletube22"];
                bool _1cleplate22 = document["1cleplate22"];
                bool _16boulonsM1030mm = document["16boulonsM1030mm"];
                bool _16ecrousM10 = document["16ecrousM10"];
                bool _1cletube17 = document["1cletube17"];
                bool _1cleplate17 = document["1cleplate17"];
                bool _112boulonsM1060mm = document["112boulonsM1060mm"];
                bool _122ecrousM14 = document["122ecrousM14"];
                bool _18boulonsM1030mm = document["18boulonsM1030mm"];
                bool _18rondellesM1430mm = document["18rondellesM1430mm"];
                bool _18plaquettesacier = document["18plaquettesacier"];
                bool _8bogeys = document["8bogeys"];
                bool _16visM416mm = document["16visM416mm"];
                bool _1tourneviscrusiforme = document["1tourneviscrusiforme"];
                bool _4visM8 = document["4visM8"];
                bool _1cleallen5mm = document["1cleallen5mm"];
                bool _1niveaulaser = document["1niveaulaser"];
                bool _1cleplate14_15 = document["1cleplate14_15"];
                bool _4carrenoirs = document["4carrenoirs"];
                bool _7marqueballe = document["7marqueballe"];
                bool _metre = document["metre"];
                bool _sparebag = document["sparebag"];
                bool _50clamps = document["50clamps"];
                bool _2pairesdegants = document["2pairesdegants"];
                bool _rangementtelec = document["rangementtelec"];
                bool _cablealimetationadapte =
                    document["cablealimetationadapte"];
                bool complete = document["complete"];

                void appliquer() {
                  print(widget.cartons.toString());
                  if (_12boulonsM1425mm &&
                      _12ecrousM14 &&
                      _1cletube22 &&
                      _1cleplate22 &&
                      _16boulonsM1030mm &&
                      _16ecrousM10 &&
                      _1cletube17 &&
                      _1cleplate17 &&
                      _112boulonsM1060mm &&
                      _122ecrousM14 &&
                      _18boulonsM1030mm &&
                      _18rondellesM1430mm &&
                      _18plaquettesacier &&
                      _8bogeys &&
                      _16visM416mm &&
                      _1tourneviscrusiforme &&
                      _4visM8 &&
                      _1cleallen5mm &&
                      _1niveaulaser &&
                      _1cleplate14_15 &&
                      _4carrenoirs &&
                      _7marqueballe &&
                      _metre &&
                      _sparebag &&
                      _50clamps &&
                      _2pairesdegants &&
                      _rangementtelec &&
                      _cablealimetationadapte) {
                    complete = true;
                    if (widget.cartons == true) {
                      checkListInstance
                          .doc(widget.btuid.toString())
                          .update({"check1": true});
                      checkListInstance
                          .doc(widget.btuid.toString())
                          .update({"check1user": user.name});
                    } else {}
                  } else {
                    complete = false;
                    checkListInstance
                        .doc(widget.btuid.toString())
                        .update({"check1": false});
                  }
                  databaseChecklists.saveCheckListCartons12(
                      int.parse(widget.btuid),
                      _12boulonsM1425mm,
                      _12ecrousM14,
                      _1cletube22,
                      _1cleplate22,
                      _16boulonsM1030mm,
                      _16ecrousM10,
                      _1cletube17,
                      _1cleplate17,
                      _112boulonsM1060mm,
                      _122ecrousM14,
                      _18boulonsM1030mm,
                      _18rondellesM1430mm,
                      _18plaquettesacier,
                      _8bogeys,
                      _16visM416mm,
                      _1tourneviscrusiforme,
                      _4visM8,
                      _1cleallen5mm,
                      _1niveaulaser,
                      _1cleplate14_15,
                      _4carrenoirs,
                      _7marqueballe,
                      _metre,
                      _sparebag,
                      _50clamps,
                      _2pairesdegants,
                      _rangementtelec,
                      _cablealimetationadapte,
                      complete);
                }

                return SingleChildScrollView(
                  child: Column(
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
                              title: Text(stringslist[0]),
                              value: _12boulonsM1425mm,
                              onChanged: (bool newbox) {
                                _12boulonsM1425mm = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[1]),
                              value: _12ecrousM14,
                              onChanged: (bool newbox) {
                                _12ecrousM14 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[2]),
                              value: _1cletube22,
                              onChanged: (bool newbox) {
                                _1cletube22 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[3]),
                              value: _1cleplate22,
                              onChanged: (bool newbox) {
                                _1cleplate22 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[4]),
                              value: _16boulonsM1030mm,
                              onChanged: (bool newbox) {
                                _16boulonsM1030mm = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[5]),
                              value: _16ecrousM10,
                              onChanged: (bool newbox) {
                                _16ecrousM10 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[6]),
                              value: _1cletube17,
                              onChanged: (bool newbox) {
                                _1cletube17 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[7]),
                              value: _1cleplate17,
                              onChanged: (bool newbox) {
                                _1cleplate17 = newbox;
                                appliquer();
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
                              title: Text(stringslist[8]),
                              value: _112boulonsM1060mm,
                              onChanged: (bool newbox) {
                                _112boulonsM1060mm = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[9]),
                              value: _122ecrousM14,
                              onChanged: (bool newbox) {
                                _122ecrousM14 = newbox;
                                appliquer();
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
                              title: Text(stringslist[10]),
                              value: _18boulonsM1030mm,
                              onChanged: (bool newbox) {
                                _18boulonsM1030mm = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[11]),
                              value: _18rondellesM1430mm,
                              onChanged: (bool newbox) {
                                _18rondellesM1430mm = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[12]),
                              value: _18plaquettesacier,
                              onChanged: (bool newbox) {
                                _18plaquettesacier = newbox;
                                appliquer();
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
                              title: Text(stringslist[13]),
                              value: _8bogeys,
                              onChanged: (bool newbox) {
                                _8bogeys = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[14]),
                              value: _16visM416mm,
                              onChanged: (bool newbox) {
                                _16visM416mm = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[15]),
                              value: _1tourneviscrusiforme,
                              onChanged: (bool newbox) {
                                _1tourneviscrusiforme = newbox;
                                appliquer();
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
                              title: Text(stringslist[16]),
                              value: _4visM8,
                              onChanged: (bool newbox) {
                                _4visM8 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[17]),
                              value: _1cleallen5mm,
                              onChanged: (bool newbox) {
                                _1cleallen5mm = newbox;
                                appliquer();
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
                              title: Text(stringslist[18]),
                              value: _1niveaulaser,
                              onChanged: (bool newbox) {
                                _1niveaulaser = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[19]),
                              value: _1cleplate14_15,
                              onChanged: (bool newbox) {
                                _1cleplate14_15 = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[20]),
                              value: _4carrenoirs,
                              onChanged: (bool newbox) {
                                _4carrenoirs = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[21]),
                              value: _7marqueballe,
                              onChanged: (bool newbox) {
                                _7marqueballe = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[22]),
                              value: _metre,
                              onChanged: (bool newbox) {
                                _metre = newbox;
                                appliquer();
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
                              title: Text(stringslist[23]),
                              value: _sparebag,
                              onChanged: (bool newbox) {
                                _sparebag = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[24]),
                              value: _50clamps,
                              onChanged: (bool newbox) {
                                _50clamps = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[25]),
                              value: _2pairesdegants,
                              onChanged: (bool newbox) {
                                _2pairesdegants = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[26]),
                              value: _rangementtelec,
                              onChanged: (bool newbox) {
                                _rangementtelec = newbox;
                                appliquer();
                              })),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10), //apply padding to all four sides
                          child: CheckboxListTile(
                              title: Text(stringslist[27]),
                              value: _cablealimetationadapte,
                              onChanged: (bool newbox) {
                                _cablealimetationadapte = newbox;
                                appliquer();
                              })),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
