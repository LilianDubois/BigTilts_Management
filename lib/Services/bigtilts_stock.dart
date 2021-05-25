import 'package:bigtitlss_management/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigtiltsStock extends StatelessWidget {
  BigtiltsStock(String _taille) {
    this.taille = _taille;
  }

  String taille = 'lol';
  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<List<AppStockData>>(context) ?? [];
    int i = 0;
    String statu = 'Le stock permet la création d\'une nouvelle BigTilt';
    bool val = false;

    test(numero) {
      if (numero == '4 * 200') {
        for (i = 0; i < stock.length; i++) {
          if (int.parse(stock[i].quantity_400_200) <=
              int.parse(stock[i].real_quantity)) {
          } else {
            val = true;
          }
        }
      }
      ;
      if (numero == '3 * 200') {
        for (i = 0; i < stock.length; i++) {
          if (int.parse(stock[i].quantity_300_200) <=
              int.parse(stock[i].real_quantity)) {
          } else {
            val = true;
          }
        }
      }
      ;
      if (numero == '5 * 200') {
        for (i = 0; i < stock.length; i++) {
          if (int.parse(stock[i].quantity_500_200) <=
              int.parse(stock[i].real_quantity)) {
          } else {
            val = true;
          }
        }
      }
      ;
    }

    test(taille);

    if (val)
      statu =
          'Attention le stock ne permet pas la création d\'une nouvelle BigTilt de cette taille';
    return Text(
      statu,
      style: TextStyle(color: val ? Colors.red : Colors.green, fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}
