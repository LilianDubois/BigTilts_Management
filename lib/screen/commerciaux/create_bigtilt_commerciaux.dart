import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/bigtilts_stock.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';

import 'package:bigtitlss_management/models/stock.dart';

import 'package:bigtitlss_management/screen/home/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';

class CreateBigtiltCommerciaux extends StatefulWidget {
  var uid;
  var lenght;
  CreateBigtiltCommerciaux(this.uid, this.lenght);

  @override
  _CreateBigtiltCommerciauxState createState() =>
      _CreateBigtiltCommerciauxState();
}

class _CreateBigtiltCommerciauxState extends State<CreateBigtiltCommerciaux> {
  final database = DatabaseBigtilts();
  final databasestock = DatabaseStock();
  final nomController = TextEditingController();

  String _selectedindex = flowerItems.first;
  String _selectedmateriaux = materiauxitems.first;
  String _selectedDeco = decoItems.first;
  String _selectedPlancher = plancheritems.first;
  String _selectedTaille = tailleitems.first;
  String _selectedTapis = tapisitems.first;
  String _selectedTapissub = tapissubitems.first;
  String _selectedTransport = transportitems.first;
  String _selectedTypevideo = videotypeitems.first;
  bool darkmode = false;
  dynamic savedThemeMode;

  bool vendue = false;
  bool atleiervalid = false;
  bool videoproj = false;
  String dateexp;

  static final List<String> flowerItems = <String>[
    '-',
    '0.1',
    '0.2',
  ];
  static final List<String> decoItems = <String>[
    '-',
    'Classique',
    'Custom',
  ];
  static final List<String> materiauxitems = <String>[
    '-',
    'MDFF',
    'PLA',
  ];
  static final List<String> plancheritems = <String>[
    '-',
    'Forex',
    'Aglo22',
  ];
  static final List<String> tailleitems = <String>[
    '-',
    '3 * 200',
    '4 * 200',
    '5 * 200',
  ];
  static final List<String> tapisitems = <String>[
    '-',
    'Sprint',
    'Mercury',
  ];
  static final List<String> tapissubitems = <String>[
    '-',
    'Classique',
    'Custom',
  ];
  static final List<String> transportitems = <String>[
    '-',
    'Bateau Horizontale',
    'Bateau Verticale',
    'Avion Horizontale',
  ];
  static final List<String> videotypeitems = <String>[
    '-',
    'Android TV',
    'Android',
  ];

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
    final stock = Provider.of<List<AppStockData>>(context) ?? [];
    var incrementednumber = widget.lenght + 1;
    final numController =
        TextEditingController(text: incrementednumber.toString());

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      numController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text('Nouvelle Bigtilt'),
        elevation: 0.0,
      ),
      body: Container(
        //decoration: new BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FractionallySizedBox(
                child: Container(
                  height: 20,
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
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
                        Text('Vendue ?'),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: vendue,
                            onChanged: (bool newval) {
                              setState(() {
                                vendue = newval;
                              });
                            })
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nom du client :'),
                        Flexible(
                            child: Container(
                          width: 200,
                          child: TextField(
                            controller: nomController,
                            decoration: InputDecoration(
                              hintText: "Nom",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )),
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Numéro :'),
                        Text(
                          '${incrementednumber.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Type de chassis'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedindex,

                            items: flowerItems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Matériaux modules'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedmateriaux,

                            items: materiauxitems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Plancher'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedPlancher,

                            items: plancheritems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Décoration modules'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedDeco,
                            onChanged: (value) => setState(() {
                              _selectedDeco = value;
                            }),
                            items: decoItems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Taille'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedTaille,
                            onChanged: (value) => setState(() {
                              _selectedTaille = value;
                            }),
                            items: tailleitems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                    borderRadius: new BorderRadius.vertical(
                      top: const Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tapis'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedTapis,
                            onChanged: (value) => setState(() {
                              _selectedTapis = value;
                            }),
                            items: tapisitems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                    borderRadius: new BorderRadius.vertical(
                      bottom: const Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Type de tapis'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedTapissub,
                            onChanged: (value) => setState(() {
                              _selectedTapissub = value;
                            }),
                            items: tapissubitems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transport'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            dropdownColor: Colors.grey,
                            value: _selectedTransport,

                            onChanged: (value) => setState(() {
                              _selectedTransport = value;
                            }),
                            items: transportitems
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 100,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                    borderRadius: new BorderRadius.vertical(
                      top: const Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date d\'expé'),
                        Flexible(
                          child: Container(
                            width: 200,
                            child: DateTimeFormField(
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color:
                                        darkmode ? Colors.white : Colors.black),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.event_note),
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              autovalidateMode: AutovalidateMode.always,
                              onDateSelected: (DateTime value) {
                                var date = (value).toString();
                                dateexp = date.substring(0, 10);
                              },
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                    borderRadius: new BorderRadius.vertical(
                      bottom: const Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Validation de l\'atelier'),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: atleiervalid,
                            onChanged: (atleiervalid) {
                              setState(() {});
                            })
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                    borderRadius: new BorderRadius.vertical(
                      top: const Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Vidéo projecteur'),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: videoproj,
                            onChanged: (bool newval) {
                              setState(() {
                                videoproj = newval;
                              });
                            })
                      ]),
                ),
              ),
              if (videoproj)
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: new BoxDecoration(
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4),
                      borderRadius: new BorderRadius.vertical(
                        bottom: const Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Type'),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              // isExpanded: true,
                              dropdownColor: Colors.grey,
                              value: _selectedTypevideo,

                              items: videotypeitems
                                  .map((item) => DropdownMenuItem(
                                        child: Text(
                                          item,
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
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<AppStockData>(
                        stream: databasestock.stock,
                        builder: (context, snapshot) {
                          return BigtiltsStock(_selectedTaille);
                        }),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              FlatButton(
                child: Text(
                  'Creer la nouvelle BigTilt',
                  style: TextStyle(),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 5, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.all(20),
                onPressed: () {
                  if (_selectedTaille == '4 * 200') {
                    for (var i = 0; i < stock.length; i++) {
                      int realquantity1 = int.parse(stock[i].real_quantity) -
                          int.parse(stock[i].quantity_400_200);
                      databasestock.saveStock(
                          stock[i].uid,
                          stock[i].name,
                          stock[i].quantity_500_200,
                          stock[i].quantity_400_200,
                          stock[i].quantity_300_200,
                          realquantity1.toString());
                    }
                  }
                  if (_selectedTaille == '3 * 200') {
                    for (var i = 0; i < stock.length; i++) {
                      int realquantity2 = int.parse(stock[i].real_quantity) -
                          int.parse(stock[i].quantity_300_200);
                      databasestock.saveStock(
                          stock[i].uid,
                          stock[i].name,
                          stock[i].quantity_500_200,
                          stock[i].quantity_400_200,
                          stock[i].quantity_300_200,
                          realquantity2.toString());
                    }
                  }
                  if (_selectedTaille == '5 * 200') {
                    for (var i = 0; i < stock.length; i++) {
                      int realquantity3 = int.parse(stock[i].real_quantity) -
                          int.parse(stock[i].quantity_500_200);
                      databasestock.saveStock(
                          stock[i].uid,
                          stock[i].name,
                          stock[i].quantity_500_200,
                          stock[i].quantity_400_200,
                          stock[i].quantity_300_200,
                          realquantity3.toString());
                    }
                  }

                  database.saveBigtilt(
                      '${numController.text}',
                      vendue,
                      nomController.text,
                      _selectedindex,
                      _selectedmateriaux,
                      _selectedDeco,
                      _selectedPlancher,
                      _selectedTaille,
                      _selectedTapis,
                      _selectedTapissub,
                      dateexp,
                      atleiervalid,
                      _selectedTransport,
                      videoproj,
                      _selectedTypevideo);

                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new HomeScreen()));
                },
              ),
              SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
