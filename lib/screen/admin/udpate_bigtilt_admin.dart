import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/bigtilts_stock.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';
import 'package:bigtitlss_management/Services/picture.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/pdf/pdf_api.dart';
import 'package:bigtitlss_management/screen/bigtilt_details.dart';
import 'package:bigtitlss_management/screen/changestateBT.dart';
import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class UpdateBigtiltAdmin extends StatefulWidget {
  var currentUid;

  UpdateBigtiltAdmin(
    this.currentUid,
  );

  @override
  _UpdateBigtiltAdminState createState() => _UpdateBigtiltAdminState();
}

class _UpdateBigtiltAdminState extends State<UpdateBigtiltAdmin> {
  final database = DatabaseBigtilts();
  final databasestock = DatabaseStock();
  final databaselogs = DatabaseLogs();

  final numController = TextEditingController();
  final infosController = TextEditingController();

  bool vendue = false;
  bool codeexists = false;

  bool darkmode = false;
  dynamic savedThemeMode;
  String colorBorder;
  bool infosSaved = false;

  bool dateatelierisString = false;
  bool datedexpeisString = false;

  File customImageFile1 = File("assets/img/white.png");
  File customImageFile2 = File("assets/img/white.png");
  File customImageFile3 = File("assets/img/white.png");
  String photo1link;
  String photo2link;
  String photo3link;
  bool photo1 = false;
  bool photo2 = false;
  bool photo3 = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numController.dispose();
    infosController.dispose();
    super.dispose();
  }

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

  Future<void> delete(String bigtiltId) {
    return FirebaseFirestore.instance
        .collection('bigtilts')
        .doc(bigtiltId)
        .delete();
  }

  Future asimage() async {
    try {
      var lien = await FirebaseStorage.instance
          .ref('Bigtilt' + '${widget.currentUid}' + 'photo1')
          .getDownloadURL();
      photo1link = lien;
      photo1 = true;
    } catch (e) {
      var lienblank =
          await FirebaseStorage.instance.ref('white.png').getDownloadURL();
      photo1link = lienblank;
      print('erreur catché');
    }
    try {
      var lien = await FirebaseStorage.instance
          .ref('Bigtilt' + '${widget.currentUid}' + 'photo2')
          .getDownloadURL();
      photo2link = lien;
      photo2 = true;
    } catch (e) {
      var lienblank =
          await FirebaseStorage.instance.ref('white.png').getDownloadURL();
      photo2link = lienblank;
    }
    try {
      var lien = await FirebaseStorage.instance
          .ref('Bigtilt' + '${widget.currentUid}' + 'photo3')
          .getDownloadURL();
      photo3link = lien;
      photo3 = true;
    } catch (e) {
      var lienblank =
          await FirebaseStorage.instance.ref('white.png').getDownloadURL();
      photo3link = lienblank;
    }
    setState(() {});
  }

  void initState() {
    super.initState();
    getCurrentTheme();
    asimage();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
        colorBorder = 'Colors.white';
      });
    } else {
      setState(() {
        darkmode = false;
        colorBorder = 'Colors.black';
      });
    }
  }

  String nomControllerval;
  String infosControllerval;
  String codeControllerval;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final bigtiltsInstance = FirebaseFirestore.instance.collection("bigtilts");
    AppBigTiltsData bigtilt;
    AppUserData user;

    List _items = [];
    List _itemscode = [];

    var date;

    var indexbt = 0;
    while (bigtiltlist[indexbt].id != widget.currentUid) {
      indexbt++;
    }
    bigtilt = bigtiltlist[indexbt];

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    user = users[index];

    final stock = Provider.of<List<AppStockData>>(context) ?? [];
    final nomController = TextEditingController(text: nomControllerval);
    final infosController = TextEditingController(text: infosControllerval);
    final codeController = TextEditingController(text: codeControllerval);

    if (nomController.text != "") {
      nomControllerval = nomController.text;
    } else {
      nomControllerval = bigtilt.nomclient;
    }
    if (infosController.text != "") {
      infosControllerval = infosController.text;
    } else {
      infosControllerval = bigtilt.infos;
    }
    if (codeController.text != "") {
      codeControllerval = codeController.text;
    } else {
      codeControllerval = bigtilt.countrycode;
    }

    Future<void> logsaving(String item, String id) async {
      databaselogs.saveLogs(
          '${DateTime.now().toString()}',
          user.name,
          'a modifié la bigtilt $id ($item)',
          DateTime.now().toString(),
          bigtilt.id.toString());
    }

    void _showImageSourceActionSheet(BuildContext context, int number) {
      if (Platform.isIOS) {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('Camera'),
                onPressed: () async {
                  Navigator.pop(context);

                  var image =
                      await ImagePicker().getImage(source: ImageSource.camera);
                  this.setState(() {
                    if (number == 1) customImageFile1 = File(image.path);
                    if (number == 2) customImageFile2 = File(image.path);
                    if (number == 3) customImageFile3 = File(image.path);
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage
                        .ref()
                        .child('Bigtilt${widget.currentUid}photo$number');
                    UploadTask uploadTask = ref.putFile(File(image.path));
                    uploadTask.then((res) {
                      photo1link = (res.ref.getDownloadURL()).toString();
                    });
                  });
                  databaselogs.saveLogs(
                      '${DateTime.now().toString()}',
                      user.name,
                      'a ajouté une photo ($number) à la bigtilt ${widget.currentUid}',
                      DateTime.now().toString(),
                      widget.currentUid.toString());
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Gallery'),
                onPressed: () async {
                  Navigator.pop(context);

                  var image =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  this.setState(() {
                    if (number == 1) customImageFile1 = File(image.path);
                    if (number == 2) customImageFile2 = File(image.path);
                    if (number == 3) customImageFile3 = File(image.path);
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage
                        .ref()
                        .child('Bigtilt${widget.currentUid}photo$number');
                    UploadTask uploadTask = ref.putFile(File(image.path));
                    uploadTask.then((res) {
                      photo1link = (res.ref.getDownloadURL()).toString();
                    });
                  });
                  databaselogs.saveLogs(
                      '${DateTime.now().toString()}',
                      user.name,
                      'a ajouté une photo ($number) à la bigtilt ${widget.currentUid}',
                      DateTime.now().toString(),
                      widget.currentUid.toString());
                },
              )
            ],
          ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context);

                var image =
                    await ImagePicker().getImage(source: ImageSource.camera);
                this.setState(() {
                  if (number == 1) customImageFile1 = File(image.path);
                  if (number == 2) customImageFile2 = File(image.path);
                  if (number == 3) customImageFile3 = File(image.path);
                  FirebaseStorage storage = FirebaseStorage.instance;
                  Reference ref = storage
                      .ref()
                      .child('Bigtilt${widget.currentUid}photo$number');
                  UploadTask uploadTask = ref.putFile(File(image.path));
                  uploadTask.then((res) {
                    photo1link = (res.ref.getDownloadURL()).toString();
                  });
                });
                databaselogs.saveLogs(
                    '${DateTime.now().toString()}',
                    user.name,
                    'a ajouté une photo ($number) à la bigtilt ${widget.currentUid}',
                    DateTime.now().toString(),
                    widget.currentUid.toString());
              },
            ),
            ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);

                  var image =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  this.setState(() {
                    if (number == 1) customImageFile1 = File(image.path);
                    if (number == 2) customImageFile2 = File(image.path);
                    if (number == 3) customImageFile3 = File(image.path);
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage
                        .ref()
                        .child('Bigtilt${widget.currentUid}photo$number');
                    UploadTask uploadTask = ref.putFile(File(image.path));
                    uploadTask.then((res) {
                      photo1link = (res.ref.getDownloadURL()).toString();
                    });
                  });
                  databaselogs.saveLogs(
                      '${DateTime.now().toString()}',
                      user.name,
                      'a ajouté une photo ($number) à la bigtilt ${widget.currentUid}',
                      DateTime.now().toString(),
                      widget.currentUid.toString());
                }),
          ]),
        );
      }
    }

    void actionimage(int number, bool isempty) {
      if (!isempty)
        _showImageSourceActionSheet(context, number);
      else if (Platform.isIOS) {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('Supprimer'),
                onPressed: () async {
                  if (number == 1) photo1 = false;
                  if (number == 2) photo2 = false;
                  if (number == 3) photo3 = false;
                  Navigator.pop(context);
                  FirebaseStorage.instance
                      .ref('Bigtilt${widget.currentUid}photo$number')
                      .delete();
                  databaselogs.saveLogs(
                      '${DateTime.now().toString()}',
                      user.name,
                      'a supprimé une photo ($number) de la bigtilt ${widget.currentUid}',
                      DateTime.now().toString(),
                      widget.currentUid.toString());
                  setState(() {});
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Voir'),
                onPressed: () async {
                  Navigator.pop(context);
                  var image = await FirebaseStorage.instance
                      .ref('Bigtilt${widget.currentUid}photo$number')
                      .getDownloadURL();

                  print('file : $image');
                  await canLaunch(image)
                      ? await launch(image)
                      : throw 'Could not launch $image';
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Modifier'),
                onPressed: () {
                  if (number == 1) photo1 = false;
                  if (number == 2) photo2 = false;
                  if (number == 3) photo3 = false;
                  Navigator.pop(context);
                  _showImageSourceActionSheet(context, number);
                },
              )
            ],
          ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Supprimer'),
              onTap: () async {
                if (number == 1) photo1 = false;
                if (number == 2) photo2 = false;
                if (number == 3) photo3 = false;
                Navigator.pop(context);
                FirebaseStorage.instance
                    .ref('Bigtilt${widget.currentUid}photo$number')
                    .delete();
                databaselogs.saveLogs(
                    '${DateTime.now().toString()}',
                    user.name,
                    'a supprimé une photo ($number) de la bigtilt ${widget.currentUid}',
                    DateTime.now().toString(),
                    widget.currentUid.toString());
                setState(() {});
              },
            ),
            ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Voir'),
                onTap: () async {
                  Navigator.pop(context);
                  var image = await FirebaseStorage.instance
                      .ref('Bigtilt${widget.currentUid}photo$number')
                      .getDownloadURL();

                  print('file : $image');
                  await canLaunch(image)
                      ? await launch(image)
                      : throw 'Could not launch $image';
                }),
            ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Modifier'),
                onTap: () async {
                  if (number == 1) photo1 = false;
                  if (number == 2) photo2 = false;
                  if (number == 3) photo3 = false;
                  Navigator.pop(context);
                  _showImageSourceActionSheet(context, number);
                }),
          ]),
        );
      }
    }

    textString() {
      try {
        DateFormat('d MMMM y', 'fr_FR')
            .format(DateTime.parse(bigtilt.date_atelier));
      } on Exception catch (_) {
        dateatelierisString = true;
      }
      try {
        DateFormat('d MMMM y', 'fr_FR')
            .format(DateTime.parse(bigtilt.date_exp));
      } on Exception catch (_) {
        datedexpeisString = true;
      }
    }

    textString();

    btVendue() {
      // coher ou non le switch ve due en fonction de l'etat
      if (bigtilt.status == 'Vendue' ||
          bigtilt.status == 'Vendue US' ||
          bigtilt.status == 'Expédiée' ||
          bigtilt.status == 'Expediées' ||
          bigtilt.status == 'Livrée' ||
          bigtilt.status == 'En place chez le client')
        vendue = true;
      else
        vendue = false;
    }

    btVendue();

    Future<void> readJson(String code) async {
      final String response =
          await rootBundle.loadString('assets/countrycodes.json');
      final data = await json.decode(response);

      setState(() {
        _items = data["items"];
      });
      for (var i = 0; i < _items.length; i++) {
        if (code == _items[i]['code']) {
          setState(() {
            codeexists = true;
          });
          print(codeexists);
          break;
        } else {
          setState(() {
            codeexists = false;
          });
          print(codeexists);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Bigtilt N°${widget.currentUid}'),
        elevation: 0.0,
      ),
      body: Container(
        //decoration: new BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              if (bigtilt.status == 'En stock FR' ||
                  bigtilt.status == 'Expediée' ||
                  bigtilt.status == 'Vendue US' ||
                  bigtilt.status == 'Expédiée' ||
                  bigtilt.status == 'Livrée')
                ChangeStateBT(bigtilt.id, bigtilt.status),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vendue ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: vendue,
                            onChanged: (bool newval) {
                              logsaving(
                                  'Statut Vendue ?', bigtilt.id.toString());
                              setState(() {
                                vendue = newval;
                                if (newval == true) {
                                  if (bigtilt.status != "En stock US") {
                                    bigtiltsInstance
                                        .doc(bigtilt.id.toString())
                                        .update({"status": "Vendue"});
                                  } else if (bigtilt.status == "En stock US") {
                                    bigtiltsInstance
                                        .doc(bigtilt.id.toString())
                                        .update({"status": "Vendue US"});
                                  }
                                } else if (newval == false) {
                                  bigtiltsInstance
                                      .doc(bigtilt.id.toString())
                                      .update({"status": "Réservée"});
                                }
                              });
                            })
                      ]),
                ),
              ),
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nom du client :'),
                            FlatButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      readJson(bigtilt.countrycode);
                                      return Container(
                                        height: 700,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text('Enter le nom du client'),
                                                SizedBox(height: 10),
                                                Flexible(
                                                    child: Container(
                                                  child: TextField(
                                                    controller: nomController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Nom',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    onChanged: (value) {
                                                      nomControllerval = value;
                                                    },
                                                  ),
                                                )),
                                                SizedBox(height: 30),
                                                Text(
                                                    'Entrer le code pays (2 lettres)'),
                                                Text(
                                                    'Pour les USA vous devez precisez l\'état'),
                                                Text('Ex Alabama : US-AL'),
                                                SizedBox(height: 10),
                                                Flexible(
                                                    child: Container(
                                                  child: TextField(
                                                    controller: codeController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Pays',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    onChanged: (value) {
                                                      codeControllerval = value;
                                                      readJson(value);
                                                    },
                                                  ),
                                                )),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Annuler'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    SizedBox(width: 10),
                                                    ElevatedButton(
                                                        child: const Text(
                                                            'Valider'),
                                                        onPressed: () {
                                                          setState(() {});
                                                          if (codeexists) {
                                                            logsaving(
                                                                'Nom du client',
                                                                bigtilt.id
                                                                    .toString());
                                                            bigtiltsInstance
                                                                .doc(bigtilt.id
                                                                    .toString())
                                                                .update({
                                                              "nomclient":
                                                                  nomControllerval
                                                            });
                                                            logsaving(
                                                                'Code pays',
                                                                bigtilt.id
                                                                    .toString());
                                                            bigtiltsInstance
                                                                .doc(bigtilt.id
                                                                    .toString())
                                                                .update({
                                                              "countrycode":
                                                                  codeControllerval
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          } else {
                                                            showDialog<void>(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false, // user must tap button!
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Attention'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        ListBody(
                                                                      children: const <
                                                                          Widget>[
                                                                        Text(
                                                                            'Ce code pays n\existe pas'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'OK'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'Voir la liste des codes pays'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        showDialog<
                                                                            void>(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              scrollable: true,
                                                                              title: const Text('Attention'),
                                                                              content: Container(
                                                                                height: 300.0, // Change as per your requirement
                                                                                width: 300.0,
                                                                                child: ListView.builder(
                                                                                  itemCount: _items.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Card(
                                                                                      margin: const EdgeInsets.all(10),
                                                                                      child: ListTile(
                                                                                        trailing: Text(_items[index]["code"]),
                                                                                        title: Text(_items[index]["county"]),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  child: const Text('OK'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        }),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text("Modifier",
                                    style: TextStyle(color: Colors.blue)))
                          ],
                        ),
                        Text(
                          '${bigtilt.nomclient}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Divider(thickness: 2, color: Colors.black),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Code Pays : ',
                              ),
                              Text(''),
                            ]),
                        Text(
                          '${bigtilt.countrycode}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Numéro :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${widget.currentUid}',
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
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Taille',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

                            value: bigtilt.taille,
                            onChanged: (value) {
                              logsaving('Taille', bigtilt.id.toString());
                              bigtiltsInstance
                                  .doc(bigtilt.id.toString())
                                  .update({"taille": value});
                            },
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
                      borderRadius:
                          new BorderRadius.vertical(top: Radius.circular(10)),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tapis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

                            value: bigtilt.tapis,
                            onChanged: (value) {
                              logsaving('Tapis', bigtilt.id.toString());
                              bigtiltsInstance
                                  .doc(bigtilt.id.toString())
                                  .update({"tapis": value});
                            },

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
                      borderRadius: new BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Type de tapis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

                            value: bigtilt.tapistype,

                            onChanged: (value) {
                              logsaving('Type tapis', bigtilt.id.toString());
                              bigtiltsInstance
                                  .doc(bigtilt.id.toString())
                                  .update({"Type tapis": value});
                            },
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
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pack Marketing',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: bigtilt.pack_marketing,
                            onChanged: (bool newval) {
                              logsaving(
                                  'Pack Marketing', bigtilt.id.toString());
                              bigtiltsInstance
                                  .doc(bigtilt.id.toString())
                                  .update({"pack_marketing": newval});
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
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transport',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

                            value: bigtilt.transport_type,
                            onChanged: (value) {
                              logsaving('Transport', bigtilt.id.toString());
                              bigtiltsInstance
                                  .doc(bigtilt.id.toString())
                                  .update({"transport_type": value});
                            },
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
                  height: 90,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.vertical(top: Radius.circular(10)),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date d\'expédition actuelle :'),
                            FlatButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 500,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    'Enter la nouvelle date d\'expédition'),
                                                SizedBox(height: 30),
                                                Flexible(
                                                  child: Container(
                                                    width: 150,
                                                    child: DateTimeFormField(
                                                      dateTextStyle: TextStyle(
                                                        color: darkmode
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle: TextStyle(
                                                          color: darkmode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        errorStyle: TextStyle(
                                                          color: darkmode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        suffixIcon: Icon(
                                                          Icons.event_note,
                                                        ),
                                                      ),
                                                      mode:
                                                          DateTimeFieldPickerMode
                                                              .date,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      onDateSelected:
                                                          (DateTime value) {
                                                        date =
                                                            (value).toString();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Annuler'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    SizedBox(width: 10),
                                                    ElevatedButton(
                                                        child: const Text(
                                                            'Valider'),
                                                        onPressed: () {
                                                          logsaving(
                                                              'Date d\'expédition',
                                                              bigtilt.id
                                                                  .toString());
                                                          bigtiltsInstance
                                                              .doc(bigtilt.id
                                                                  .toString())
                                                              .update({
                                                            "date_exp":
                                                                date.substring(
                                                                    0, 10)
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text("Modifier",
                                    style: TextStyle(color: Colors.blue)))
                          ],
                        ),
                        Text(
                          datedexpeisString
                              ? '${bigtilt.date_exp}'
                              : '${DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(bigtilt.date_exp))}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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
                    borderRadius:
                        new BorderRadius.vertical(bottom: Radius.circular(10)),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Validation de l\'atelier',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: bigtilt.date_valid,
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
                          hintText: 'Informatons complémentaires',
                        ),
                        onChanged: (value) {
                          infosControllerval = value;
                        },
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.blue,
                                width: 5,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          setState(() {
                            infosSaved = true;
                          });
                          logsaving('Infos', bigtilt.id.toString());
                          bigtiltsInstance
                              .doc(bigtilt.id.toString())
                              .update({"infos": infosControllerval});
                        },
                        child: Text("Enregitrer")),
                    SizedBox(width: 30),
                    Text(infosSaved ? "Infos Enregistrées" : "")
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: GestureDetector(
                  onTap: () async {
                    final pdfFile = await PdfApi.generateCenteredText(
                        '${widget.currentUid}',
                        bigtilt.nomclient,
                        bigtilt.chassit,
                        bigtilt.materiaux,
                        bigtilt.plancher,
                        bigtilt.deco_module,
                        bigtilt.taille,
                        bigtilt.tapis,
                        bigtilt.tapistype,
                        bigtilt.pack_marketing,
                        bigtilt.transport_type,
                        bigtilt.date_exp,
                        bigtilt.videoproj,
                        bigtilt.videoproj_type,
                        bigtilt.infos);

                    PdfApi.openFile(pdfFile);
                  },
                  child: Text(
                    "Obtenir la fiche PDF de cette Bigtilt",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 150,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: photo1
                              ? NetworkImage(photo1link)
                              : FileImage(customImageFile1),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.circular(10),
                        border: Border.all(
                            color: darkmode ? Colors.white : Colors.black,
                            width: 4),
                      ),
                      child: FlatButton(
                        child: photo1
                            ? Text(
                                '',
                                style: TextStyle(),
                              )
                            : Icon(Icons.add_a_photo_outlined,
                                color: Colors.blue),
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          print(customImageFile1);
                          actionimage(1, photo1);
                        },
                      ),
                    ),
                    Container(
                      height: 150,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: photo2
                              ? NetworkImage(photo2link)
                              : FileImage(customImageFile2),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.circular(10),
                        border: Border.all(
                            color: darkmode ? Colors.white : Colors.black,
                            width: 4),
                      ),
                      child: FlatButton(
                        child: photo2
                            ? Text(
                                '',
                                style: TextStyle(),
                              )
                            : Icon(Icons.add_a_photo_outlined,
                                color: Colors.blue),
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          actionimage(2, photo2);
                        },
                      ),
                    ),
                    Container(
                      height: 150,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: photo3
                              ? NetworkImage(photo3link)
                              : FileImage(customImageFile3),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.circular(10),
                        border: Border.all(
                            color: darkmode ? Colors.white : Colors.black,
                            width: 4),
                      ),
                      child: FlatButton(
                        child: photo3
                            ? Text(
                                '',
                                style: TextStyle(),
                              )
                            : Icon(Icons.add_a_photo_outlined,
                                color: Colors.blue),
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          actionimage(3, photo3);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new BigtiltDetails(widget.currentUid)));
                },
                child: FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: darkmode ? Colors.black : Colors.white,
                        borderRadius: new BorderRadius.circular(10),
                        boxShadow: [
                          darkmode
                              ? BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                )
                              : BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                        ],
                        border: Border.all(
                            color: darkmode ? Colors.white : Colors.black,
                            width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Voir les détails techniques de cette Bigtilt",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 20.0),
              Text("Les modifications sont enregistrés automatiquement",
                  style: TextStyle(
                    fontSize: 15,
                  )),
              SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
