import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/screen/Stock/update_stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LessElements extends StatefulWidget {
  @override
  _LessElementsState createState() => _LessElementsState();
}

class _LessElementsState extends State<LessElements> {
  var number = 10;
  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<List<AppStockData>>(context) ?? [];

    final List<String> stockuids = <String>[];

    void _displayTextInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'Pour combien de bgtilts voulez vous afficher le stock manquant ?'),
              content: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // On
                onChanged: (value) {
                  setState(() {
                    number = int.parse(value);
                  });
                },
                controller: TextEditingController(),
                decoration: InputDecoration(hintText: "Nombre de bigtilts"),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    for (var i = 0; i < stock.length; i++) {
      if (int.parse(stock[i].quantity_400_200) * number >=
              int.parse(stock[i].real_quantity) ||
          int.parse(stock[i].quantity_500_200) * number >=
              int.parse(stock[i].real_quantity) ||
          int.parse(stock[i].quantity_300_200) * number >=
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
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stock manquant pour $number bigtilt(s)'),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.orange,
                      onSurface: Colors.grey,
                    ),
                    child:
                        Text('Modifier', style: TextStyle(color: Colors.black)),
                    onPressed: () async {
                      _displayTextInputDialog(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: stockuids.length,
                    itemBuilder: (context, index) {
                      return UserTile(numero: stockuids[index]);
                    })),
          ],
        ));
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
