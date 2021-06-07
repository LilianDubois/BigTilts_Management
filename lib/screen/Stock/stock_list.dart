import 'package:bigtitlss_management/Services/bigtilts_stock.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/screen/Stock/less_elments.dart';
import 'package:bigtitlss_management/screen/Stock/update_stock.dart';
import 'package:bigtitlss_management/screen/admin/admin_user_manage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:provider/provider.dart';

class StockList extends StatefulWidget {
  List listuids;

  StockList(this.listuids);
  @override
  _StockListState createState() => _StockListState(this.listuids);
}

class _StockListState extends State<StockList> {
  _StockListState(
    var _listuid,
  ) {
    this.duplicateItems = _listuid;
  }
  TextEditingController editingController = TextEditingController();

  List<String> duplicateItems;

  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<List<AppStockData>>(context) ?? [];
    bool lesselements = false;

    final List<String> stockuids = <String>[];

    for (var i = 0; i < stock.length; i++) {
      if (int.parse(stock[i].quantity_400_200) * 10 >=
              int.parse(stock[i].real_quantity) ||
          int.parse(stock[i].quantity_500_200) * 10 >=
              int.parse(stock[i].real_quantity) ||
          int.parse(stock[i].quantity_300_200) * 10 >=
              int.parse(stock[i].real_quantity)) {
        stockuids.add(i.toString());
      }
    }
    if (!stockuids.isEmpty) lesselements = true;

    var _index = stock.length;
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          if (lesselements)
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => LessElements()));
              },
              child: Text("Voir tous les éléments manquants"),
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                AppStockData currentstock;
                var indexx = 0;
                while (stock[indexx].name != items[index]) {
                  indexx++;
                }
                currentstock = stock[indexx];

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.orange,
                          width: 5.0,
                        )),
                    margin: EdgeInsets.only(
                        top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
                    child: ListTile(
                        title: Text(
                          items[index],
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          currentstock.uid,
                        ),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            Text(
                              '${currentstock.real_quantity}',
                            ), // icon-1
                            Icon(
                              const IconData(58800,
                                  fontFamily: 'MaterialIcons'),
                            ), // icon-2
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateStock(
                                        currentstock.uid,
                                        items[index],
                                        currentstock.quantity_500_200,
                                        currentstock.quantity_400_200,
                                        currentstock.quantity_300_200,
                                        currentstock.real_quantity,
                                      )));
                        }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
