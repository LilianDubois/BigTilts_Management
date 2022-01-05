import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_checkList.dart';
import 'package:bigtitlss_management/screen/atelier/CheckList/CheckList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateCheckList extends StatefulWidget {
  var btuid;
  var btTaille;
  CreateCheckList(this.btuid, this.btTaille);

  @override
  _CreateCheckListState createState() => _CreateCheckListState();
}

final databaseCheckList = DatabaseCheckLists();
bool darkmode = false;
dynamic savedThemeMode;

int palette;
int caisse;
String error = '';

class _CreateCheckListState extends State<CreateCheckList> {
  @override
  static final List<int> palettechoices = <int>[1, 2, 3, 4, 5, 6, 7, 8];

  final firestoreInstance = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    getCurrentTheme();
  }

  definetaille() {
    switch (widget.btTaille) {
      case '5 * 200':
        return 5;
        break;

      case '4 * 200':
        return 4;
        break;

      case '3 * 200':
        return 3;
        break;

      default:
        return 0;
    }
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Text('Check List'),
          elevation: 0.0,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FractionallySizedBox(
                  child: Container(
                    height: 50,
                  ),
                ),
                //Text(widget.btuid),
                Text(
                  'Selectioner l\'emplacement \n attribuée à cette Bigtilt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 20.0),
                // ignore: deprecated_member_use
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Emplacement',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              // isExpanded: true,
                              dropdownColor: Colors.grey,
                              value: palette,

                              onChanged: (value) => setState(() {
                                palette = value;
                              }),
                              items: palettechoices
                                  .map((item) => DropdownMenuItem(
                                        child: Text(
                                          item.toString(),
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
                SizedBox(height: 100.0),
                Text(
                  'Selectioner la caisse \n attribuée à cette Bigtilt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 20.0),
                // ignore: deprecated_member_use
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Caisse',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              // isExpanded: true,
                              dropdownColor: Colors.grey,
                              value: caisse,

                              onChanged: (value) => setState(() {
                                caisse = value;
                              }),
                              items: palettechoices
                                  .map((item) => DropdownMenuItem(
                                        child: Text(
                                          item.toString(),
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
                SizedBox(height: 30.0),
                FlatButton(
                    child: Text(
                      'Creer la Check list',
                      style: TextStyle(),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.blue,
                            width: 5,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50)),
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      if (caisse == null || palette == null)
                        setState(() {
                          error = 'Les deux valeurs doivents êtres renseignées';
                        });
                      else {
                        databaseCheckList.saveCheckList(
                            int.parse(widget.btuid),
                            palette,
                            caisse,
                            definetaille(),
                            false,
                            false,
                            false,
                            false,
                            'none',
                            'none');
                        databaseCheckList.saveCheckListCartons(
                          'all',
                          int.parse(widget.btuid),
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                        );
                        databaseCheckList.saveCheckListCartons12(
                          int.parse(widget.btuid),
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                        );

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CheckList(widget.btuid)));
                      }
                      ;
                    }),
                SizedBox(height: 10.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ));
  }
}
