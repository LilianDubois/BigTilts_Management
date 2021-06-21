import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';
import 'package:bigtitlss_management/common/constants.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/Stock/stock_screen.dart';
import 'package:bigtitlss_management/screen/home/AppDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddStockScreen extends StatefulWidget {
  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final database = DatabaseStock();
  final databaselogs = DatabaseLogs();
  bool darkmode = false;
  dynamic savedThemeMode;

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
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    AppUserData user;

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    user = users[index];

    final numController = TextEditingController();
    final nameController = TextEditingController();
    final _500Controller = TextEditingController();
    final _400Controller = TextEditingController();
    final _300Controller = TextEditingController();
    final realController = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      numController.dispose();
      nameController.dispose();
      _500Controller.dispose();
      _400Controller.dispose();
      _300Controller.dispose();
      realController.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Nouvel element'),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 10.0),
          FractionallySizedBox(
            child: Container(
              height: 20,
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                border: Border.all(
                    color: darkmode ? Colors.white : Colors.black, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Référence : '),
                    Flexible(
                        child: Container(
                      width: 200,
                      child: TextField(
                        controller: numController,
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                  ]),
            ),
          ),
          SizedBox(height: 10.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                border: Border.all(
                    color: darkmode ? Colors.white : Colors.black, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nom : '),
                    Flexible(
                        child: Container(
                      width: 300,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                  ]),
            ),
          ),
          SizedBox(height: 10.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                border: Border.all(
                    color: darkmode ? Colors.white : Colors.black, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantité 500*200'),
                    Flexible(
                        child: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // On
                        controller: _500Controller,
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                  ]),
            ),
          ),
          SizedBox(height: 10.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                border: Border.all(
                    color: darkmode ? Colors.white : Colors.black, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantité 400*200'),
                    Flexible(
                        child: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // O
                        controller: _400Controller,
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                  ]),
            ),
          ),
          SizedBox(height: 10.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                border: Border.all(
                    color: darkmode ? Colors.white : Colors.black, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantité 300*200'),
                    Flexible(
                        child: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // O
                        controller: _300Controller,
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                  ]),
            ),
          ),
          SizedBox(height: 10.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                border: Border.all(
                    color: darkmode ? Colors.white : Colors.black, width: 4),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantité en stock : '),
                    Flexible(
                        child: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // O
                        controller: realController,
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                  ]),
            ),
          ),
          SizedBox(height: 30.0),
          FlatButton(
            child: Text(
              'Crer le nouvel élément',
              style: TextStyle(),
            ),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.blue, width: 5, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(20),
            onPressed: () {
              databaselogs.saveLogs(
                  '${DateTime.now().toString()}',
                  user.name,
                  'a crée le nouvel élément en stock : ${nameController.text}',
                  DateTime.now().toString(),
                  '${nameController.text}');
              database.saveStock(
                '${numController.text}',
                '${nameController.text}',
                '${_500Controller.text}',
                '${_400Controller.text}',
                '${_300Controller.text}',
                '${realController.text}',
              );
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new StockScreen()));
              /* Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new HomeScreen()));*/
            },
          ),
        ])));
  }
}
