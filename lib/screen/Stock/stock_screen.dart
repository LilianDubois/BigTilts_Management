import 'package:bigtitlss_management/Services/database_stock.dart';

import 'package:bigtitlss_management/models/stock.dart';

import 'package:bigtitlss_management/screen/Stock/add_stock.dart';
import 'package:bigtitlss_management/screen/Stock/stock_list.dart';
import 'package:bigtitlss_management/screen/home/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseStock();
    final stock = Provider.of<List<AppStockData>>(context) ?? [];

    var index = stock.length;

    final List<String> stockuids = <String>[];

    afficher() {
      for (var i = 0; i < index; i++) {
        var _uid = stock[i].name;
        stockuids.add(_uid);
      }
    }

    afficher();

    return StreamProvider<List<AppStockData>>.value(
        initialData: [],
        value: database.stocklist,
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.black,
              title: Text('Stock', style: TextStyle(fontFamily: 'Spaceage')),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text('', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new AddStockScreen()));
                  },
                )
              ],
            ),
            drawer: AppDrawer(),
            body: Container(
              child: StreamBuilder<AppStockData>(
                stream: database.stock,
                builder: (context, snapshot) {
                  return StreamProvider<List<AppStockData>>.value(
                    initialData: [],
                    value: database.stocklist,
                    child: Scaffold(
                        body: Container(
                      // decoration: new BoxDecoration(color: Colors.white),
                      child: StreamBuilder<AppStockData>(
                        stream: database.stock,
                        builder: (context, snapshot) {
                          return StockList(stockuids);
                        },
                      ),
                    )),
                  );
                },
              ),
            )));
  }
}
