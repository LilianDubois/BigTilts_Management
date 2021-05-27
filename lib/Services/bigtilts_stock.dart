import 'dart:math';

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
    String number;
    String number3;
    String number5;
    String statu = 'Le stock permet la création de $number nouvelle BigTilt';

    bool val = false;

    List _400 = [];
    List _500 = [];
    List _300 = [];

    test(numero) {
      if (numero == '4 * 200') {
        for (i = 0; i < stock.length; i++) {
          _400.add(((int.parse(stock[i].real_quantity)) /
                  (int.parse(stock[i].quantity_400_200)))
              .toString());
        }
        _400.removeWhere((item) => item == 'Infinity');
        _400.removeWhere((item) => item == 'NaN');
        List<double> nums400 = _400.map((data) => double.parse(data)).toList();
        print(nums400.reduce(min).floor());
        number = nums400.reduce(min).floor().toString();
        if (number != "0") {
          statu = 'Le stock permet la création de $number nouvelle BigTilt';
        } else {
          statu =
              'Attention le stock ne permet pas la création d\'une nouvelle BigTilt de cette taille';
          val = true;
        }
      }
      ;
      if (numero == '3 * 200') {
        for (i = 0; i < stock.length; i++) {
          _300.add(((int.parse(stock[i].real_quantity)) /
                  (int.parse(stock[i].quantity_300_200)))
              .toString());
        }
        _300.removeWhere((item) => item == 'Infinity');
        _300.removeWhere((item) => item == 'NaN');
        List<double> nums300 = _300.map((data) => double.parse(data)).toList();
        print(nums300.reduce(min).floor());
        number3 = nums300.reduce(min).floor().toString();
        if (number3 != "0") {
          statu = 'Le stock permet la création de $number3 nouvelle BigTilt';
        } else {
          statu =
              'Attention le stock ne permet pas la création d\'une nouvelle BigTilt de cette taille';
          val = true;
        }
      }
      ;
      if (numero == '5 * 200') {
        for (i = 0; i < stock.length; i++) {
          _500.add(((int.parse(stock[i].real_quantity)) /
                  (int.parse(stock[i].quantity_500_200)))
              .toString());
        }
        _500.removeWhere((item) => item == 'Infinity');
        _500.removeWhere((item) => item == 'NaN');
        List<double> nums500 = _500.map((data) => double.parse(data)).toList();
        print(nums500);
        number3 = nums500.reduce(min).floor().toString();
        if (number3 != "0") {
          statu = 'Le stock permet la création de $number3 nouvelle BigTilt';
        } else {
          statu =
              'Attention le stock ne permet pas la création d\'une nouvelle BigTilt de cette taille';
          val = true;
        }
      }
      ;
      if (numero == '-') {
        statu = '';
      }
    }

    test(taille);

    return Text(
      statu,
      style: TextStyle(color: val ? Colors.red : Colors.green, fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}
