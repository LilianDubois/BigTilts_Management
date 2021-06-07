import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/screen/Stock/stock_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class UpdateStock extends StatefulWidget {
  var uid;
  var name;
  var quantity_500_200;
  var quantity_400_200;
  var quantity_300_200;
  var real_quantity;
  UpdateStock(this.uid, this.name, this.quantity_500_200, this.quantity_400_200,
      this.quantity_300_200, this.real_quantity);

  @override
  _UpdateStockState createState() => _UpdateStockState();
}

class _UpdateStockState extends State<UpdateStock> {
  String def = null;
  bool darkmode = false;
  dynamic savedThemeMode;

  final CollectionReference stockCollection =
      FirebaseFirestore.instance.collection('stock');

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
    final database = DatabaseStock();

    void _displayTextInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Indiquer la nouvelle valeur'),
              content: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // On
                onChanged: (value) {
                  setState(() {
                    widget.real_quantity = value;
                  });
                },
                controller: TextEditingController(),
                decoration:
                    InputDecoration(hintText: "Quantité actuelle en stock"),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      database.saveStock(
                          widget.uid,
                          widget.name,
                          widget.quantity_500_200,
                          widget.quantity_400_200,
                          widget.quantity_300_200,
                          widget.real_quantity);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    return StreamProvider<List<AppStockData>>.value(
      initialData: [],
      value: database.stocklist,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.name,
          ),
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Text(
                  widget.uid,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 50,
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Quantité actuelle en stock'),
                              Text(widget.real_quantity),
                            ]),
                      ),
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text(' + 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur = int.parse(widget.real_quantity);
                                  var newvaleur = (valeur + 1).toString();
                                  widget.real_quantity = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      widget.quantity_500_200,
                                      widget.quantity_400_200,
                                      widget.quantity_300_200,
                                      newvaleur);
                                  setState(() {});
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text('- 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur = int.parse(widget.real_quantity);
                                  var newvaleur = (valeur - 1).toString();
                                  widget.real_quantity = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      widget.quantity_500_200,
                                      widget.quantity_400_200,
                                      widget.quantity_300_200,
                                      newvaleur);
                                  setState(() {});
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blue,
                                  onSurface: Colors.grey,
                                ),
                                child: Text('Modifiler la valeur',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  _displayTextInputDialog(context);
                                },
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 50,
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Quantité pour une 500*200'),
                              Text(widget.quantity_500_200),
                            ]),
                      ),
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 1),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text(' + 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur =
                                      int.parse(widget.quantity_500_200);
                                  var newvaleur = (valeur + 1).toString();
                                  widget.quantity_500_200 = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      newvaleur,
                                      widget.quantity_400_200,
                                      widget.quantity_300_200,
                                      widget.real_quantity);
                                  setState(() {});
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text('- 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur =
                                      int.parse(widget.quantity_500_200);
                                  var newvaleur = (valeur - 1).toString();
                                  widget.quantity_500_200 = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      newvaleur,
                                      widget.quantity_400_200,
                                      widget.quantity_300_200,
                                      widget.real_quantity);
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 1),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 50,
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Quantité pour une 400*200'),
                              Text(widget.quantity_400_200),
                            ]),
                      ),
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 1),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text(' + 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur =
                                      int.parse(widget.quantity_400_200);
                                  var newvaleur = (valeur + 1).toString();
                                  widget.quantity_400_200 = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      widget.quantity_500_200,
                                      newvaleur,
                                      widget.quantity_300_200,
                                      widget.real_quantity);
                                  setState(() {});
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text('- 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur =
                                      int.parse(widget.quantity_400_200);
                                  var newvaleur = (valeur - 1).toString();
                                  widget.quantity_400_200 = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      widget.quantity_500_200,
                                      newvaleur,
                                      widget.quantity_300_200,
                                      widget.real_quantity);
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 1),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 50,
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Quantité pour une 300*200'),
                              Text(widget.quantity_300_200),
                            ]),
                      ),
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 1),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text(' + 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur =
                                      int.parse(widget.quantity_300_200);
                                  var newvaleur = (valeur + 1).toString();
                                  widget.quantity_300_200 = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      widget.quantity_500_200,
                                      widget.quantity_400_200,
                                      newvaleur,
                                      widget.real_quantity);
                                  setState(() {});
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.orange,
                                  onSurface: Colors.grey,
                                ),
                                child: Text('- 1',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  var valeur =
                                      int.parse(widget.quantity_300_200);
                                  var newvaleur = (valeur - 1).toString();
                                  widget.quantity_300_200 = newvaleur;
                                  database.saveStock(
                                      widget.uid,
                                      widget.name,
                                      widget.quantity_500_200,
                                      widget.quantity_400_200,
                                      newvaleur,
                                      widget.real_quantity);
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 1),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  'Supprimer l\'élément',
                  style: TextStyle(),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.red, width: 5, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.all(20),
                onPressed: () async {
                  stockCollection.doc(widget.uid).delete();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new StockScreen()));
                },
              ),
            ],
          )),
        )),
      ),
    );
  }
}
