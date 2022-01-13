import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/bigtilts_stock.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';

import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/models/user.dart';

import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CreateBigtiltAtelier extends StatefulWidget {
  var uid;
  var lenght;
  CreateBigtiltAtelier(this.uid, this.lenght);

  @override
  _CreateBigtiltAtelierState createState() => _CreateBigtiltAtelierState();
}

class _CreateBigtiltAtelierState extends State<CreateBigtiltAtelier> {
  final database = DatabaseBigtilts();
  final databasestock = DatabaseStock();
  final databaselogs = DatabaseLogs();

  String _selectedindex = flowerItems.first;
  String _selectedmateriaux = materiauxitems.first;
  String _selectedDeco = decoItems.first;
  String _selectedPlancher = plancheritems.first;
  String _selectedTaille = tailleitems.first;
  String _selectedTapis = tapisitems.first;
  String _selectedTapissub = tapissubitems.first;
  String _selectedTransport = transportitems.first;
  String _selectedTypevideo = videotypeitems.first;
  String infos;
  bool pack_marketing = false;

  bool vendue = true;
  bool atleiervalid = false;
  bool videoproj = false;
  String dateexp = 'Non renseignée';
  String date_atelier = 'Non renseignée';
  bool darkmode = false;
  dynamic savedThemeMode;
  bool archived = false;

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
    'MDF',
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
    'Camion',
  ];
  static final List<String> videotypeitems = <String>[
    '-',
    'Android TV',
    'Android',
    'MI UITV',
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

  String infosControllerval;

  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<List<AppStockData>>(context) ?? [];

    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    AppUserData user;

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    user = users[index];

    var incrementednumber = widget.lenght;
    final numController =
        TextEditingController(text: (incrementednumber).toString());

    final infosController = TextEditingController(text: infosControllerval);

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      numController.dispose();
      infosController.dispose();
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
                  child: Text(
                    'BigTilt ${incrementednumber.toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 150,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Disponible a l\'attribution a partir du :',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
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
                                date_atelier = (value).toString();
                              },
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 200,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Container(
                    child: new ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: TextField(
                        controller: infosController,
                        decoration: InputDecoration(
                          hintText: 'Informations complémentaires',
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
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
                  databaselogs.saveLogs(
                      '${DateTime.now().toString()}',
                      user.name,
                      'a crée la bigtilt ${numController.text}',
                      DateTime.now().toString(),
                      numController.text);
                  if (_selectedTaille == '4 * 200') {
                    for (var i = 0; i < stock.length; i++) {
                      int realquantity1 = int.parse(stock[i].real_quantity) -
                          int.parse(stock[i].quantity_400_200);
                      if (realquantity1 < 0) realquantity1 = 0;
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
                      if (realquantity2 < 0) realquantity2 = 0;
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
                      if (realquantity3 < 0) realquantity3 = 0;
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
                      int.parse(numController.text),
                      "-",
                      flowerItems[2],
                      materiauxitems[1],
                      decoItems[1],
                      plancheritems[2],
                      tailleitems[3],
                      tapisitems[1],
                      tapissubitems[1],
                      false,
                      date_atelier,
                      dateexp,
                      false,
                      transportitems[0],
                      true,
                      videotypeitems[1],
                      '2.03',
                      infosController.text,
                      '-',
                      "En stock FR");

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
