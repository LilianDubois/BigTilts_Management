import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/screen/Stock/update_stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessElements extends StatefulWidget {
  @override
  _LessElementsState createState() => _LessElementsState();
}

class _LessElementsState extends State<LessElements> {
  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<List<AppStockData>>(context) ?? [];

    final List<String> stockuids = <String>[];

    for (var i = 0; i < stock.length; i++) {
      if (int.parse(stock[i].quantity_400_200) >=
              int.parse(stock[i].real_quantity) ||
          int.parse(stock[i].quantity_500_200) >=
              int.parse(stock[i].real_quantity) ||
          int.parse(stock[i].quantity_300_200) >=
              int.parse(stock[i].real_quantity)) {
        stockuids.add(i.toString());
      }
    }

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          title: Text('Stock'),
        ),
        body: ListView.builder(
            itemCount: stockuids.length,
            itemBuilder: (context, index) {
              return UserTile(numero: stockuids[index]);
            }));
  }
}

class UserTile extends StatelessWidget {
  String numero;

  UserTile({this.numero});

  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<List<AppStockData>>(context) ?? [];
    final AppStockData userr = stock[int.parse(numero)];

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.orange,
              width: 3.0,
            )),
        margin:
            EdgeInsets.only(top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
        child: ListTile(
            title: Text(userr.name),
            subtitle: Text(userr.uid),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => UpdateStock(
                            userr.uid,
                            userr.name,
                            userr.quantity_500_200,
                            userr.quantity_400_200,
                            userr.quantity_300_200,
                            userr.real_quantity,
                          )));
            }),
      ),
    );
  }
}
