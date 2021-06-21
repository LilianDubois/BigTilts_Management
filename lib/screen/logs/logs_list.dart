import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/logs.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/screen/home/AppDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LogsList extends StatefulWidget {
  @override
  _LogsListState createState() => _LogsListState();
}

Future<void> delete(String logsId) {
  return FirebaseFirestore.instance.collection('logs').doc(logsId).delete();
}

class _LogsListState extends State<LogsList> {
  String _selectedservice = serviceitems.first;
  String _selectedidbigtilt = uids.first;
  String _selectedidstock = stockuids.first;

  static final List<String> serviceitems = <String>[
    'Tout',
    'Bigtilts',
    'Stock',
    'Problèmes',
  ];

  static final List<String> uids = <String>['Tout'];
  static final List<String> stockuids = <String>['Tout'];

  @override
  Widget build(BuildContext context) {
    final logss = Provider.of<List<AppLogsData>>(context) ?? [];
    final bitilts = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final stock = Provider.of<List<AppStockData>>(context) ?? [];

    var alllogs = [];
    var specificbigtilt = [];
    var specificstock = [];

    afficher() {
      for (var i = 0; i < bitilts.length; i++) {
        var _uid = bitilts[i].id;
        uids.add(_uid.toString());
      }
      for (var i = 0; i < stock.length; i++) {
        var _uid = stock[i].name;
        stockuids.add(_uid.toString());
      }
    }

    afficher();

    trierparbt(String selectedbt) {
      for (var i = 0; i < logss.length; i++) {
        if (logss[i].relatedElementUid == selectedbt) {
          specificbigtilt.add(logss[i].uid);
        }
      }
      alllogs = specificbigtilt.toSet().toList();
    }

    trierparstock(String selectedstock) {
      for (var i = 0; i < logss.length; i++) {
        if (logss[i].relatedElementUid == selectedstock) {
          specificstock.add(logss[i].uid);
        }
      }
      alllogs = specificstock.toSet().toList();
    }

    var distinctIdsbt = uids.toSet().toList();
    var distinctIdsstock = stockuids.toSet().toList();

    void choisir() {
      for (var i = 0; i < logss.length; i++) {
        if (_selectedservice == 'Tout') {
          alllogs.add(logss[i].uid);
        } else if (_selectedservice == 'Bigtilts') {
          if (logss[i].action.contains('bigtilt')) {
            if (_selectedidbigtilt == 'Tout') {
              alllogs.add(logss[i].uid);
            } else {
              trierparbt(_selectedidbigtilt);
            }
          }
        } else if (_selectedservice == 'Stock') {
          if (logss[i].action.contains('stock')) {
            if (_selectedidstock == 'Tout') {
              alllogs.add(logss[i].uid);
            } else {
              trierparstock(_selectedidstock);
            }
          }
        } else if (_selectedservice == 'Problèmes') {
          if (logss[i].action.contains('problème')) {
            alllogs.add(logss[i].uid);
          }
        }
      }
    }

    choisir();

    Future<void> filterlogsbottom(context) async {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
                height: MediaQuery.of(context).size.height * .40,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text('Filter les logs'),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10),
                          border: Border.all(width: 4),
                        ),
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trier par type : '),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  // isExpanded: true,
                                  dropdownColor: Colors.grey,
                                  value: _selectedservice,
                                  onChanged: (value) => setState(() {
                                    _selectedservice = value;
                                    Navigator.of(context).pop();
                                    filterlogsbottom(context);
                                    //selectedservice = value;
                                  }),
                                  items: serviceitems
                                      .map((item) => DropdownMenuItem(
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            value: item,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 10.0),
                      if (_selectedservice == 'Bigtilts')
                        Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10),
                            border: Border.all(width: 4),
                          ),
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Trier par bigtilt : '),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    // isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    value: _selectedidbigtilt,
                                    onChanged: (value) => setState(() {
                                      _selectedidbigtilt = value;
                                      Navigator.of(context).pop();
                                      filterlogsbottom(context);
                                    }),
                                    items: distinctIdsbt
                                        .map((item) => DropdownMenuItem(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              value: item,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ]),
                        ),
                      SizedBox(height: 10.0),
                      if (_selectedservice == 'Stock')
                        Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10),
                            border: Border.all(width: 4),
                          ),
                          height: 100,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 10.0),
                                Text('Trier par element du stock : '),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    // isExpanded: true,
                                    dropdownColor: Colors.grey,
                                    value: _selectedidstock,
                                    onChanged: (value) => setState(() {
                                      _selectedidstock = value;
                                      Navigator.of(context).pop();
                                      filterlogsbottom(context);
                                    }),
                                    items: distinctIdsstock
                                        .map((item) => DropdownMenuItem(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              value: item,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ]),
                        ),
                    ],
                  ),
                ));
          });
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text('Logs', style: TextStyle(fontFamily: 'Spaceage')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                await filterlogsbottom(context);
                print(stockuids);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alllogs.length,
                itemBuilder: (context, index) {
                  AppLogsData currentselection;
                  var indexx = 0;
                  while (logss[indexx].uid != alllogs[index]) {
                    indexx++;
                  }
                  currentselection = logss[indexx];
                  return LogTile(log: logss[indexx]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogTile extends StatelessWidget {
  final AppLogsData log;

  LogTile({this.log});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);
    IconData monicon;

    if (log.action.contains('bigtilt')) {
      monicon = Icons.golf_course_outlined;
    } else if (log.action.contains('stock')) {
      monicon = Icons.inventory;
    } else if (log.action.contains('problème')) {
      monicon = Icons.report_problem_outlined;
    }

    var now = DateTime.now();
    var date = log.date;
    DateTime dateTime = DateTime.parse(date);
    var outputFormat = DateFormat('d MMMM y à H:m', 'fr_FR').format(dateTime);
    var nowsubDate = new DateTime(now.year - 2, now.month, now.day);
    final difference = dateTime.isBefore(nowsubDate);
    print(difference);

    if (difference) delete(log.uid);

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
        decoration: new BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 3.0, color: Colors.orange.shade900),
          ),
        ),
        child: // Row(
            // children: [
            //   Icon(monicon),
            ListTile(
          leading: Icon(monicon),
          title: Text(
            ' ${log.name} ${log.action}',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            ' le ${outputFormat}',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
        // ],
        //),
      ),
    );
  }
}
