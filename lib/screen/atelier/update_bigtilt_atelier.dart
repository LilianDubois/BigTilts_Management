import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/pdf/pdf_api.dart';
import 'package:bigtitlss_management/screen/bigtilt_details.dart';
import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:date_field/date_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class UpdateBigtiltAtelier extends StatefulWidget {
  var currentUid;
  UpdateBigtiltAtelier(
    this.currentUid,
  );

  @override
  _UpdateBigtiltAtelierState createState() => _UpdateBigtiltAtelierState();
}

class _UpdateBigtiltAtelierState extends State<UpdateBigtiltAtelier> {
  final database = DatabaseBigtilts();
  final databasestock = DatabaseStock();
  final databaselogs = DatabaseLogs();

  final numController = TextEditingController();
  final infosController = TextEditingController();

  bool vendue = false;

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

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final bigtiltsInstance = FirebaseFirestore.instance.collection("bigtilts");
    AppBigTiltsData bigtilt;
    AppUserData user;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text('Bigtilt N°${widget.currentUid}'),
            SizedBox(
              height: 5,
            ),
            Text('${bigtilt.status}',
                style: TextStyle(fontSize: 15, color: Colors.grey))
          ],
        ),
        elevation: 0.0,
      ),
      body: Container(
        //decoration: new BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  // decoration: new BoxDecoration(
                  //   border: Border.all(
                  //       color: darkmode ? Colors.white : Colors.black,
                  //       width: 4),
                  //   borderRadius: new BorderRadius.all(
                  //     Radius.circular(10.0),
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Vendue ? : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${vendue ? 'Oui' : 'Non'}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Bigtilt : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${bigtilt.id.toString()}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Nom du client : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Flexible(
                            child: Text(
                              ' ${bigtilt.nomclient}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Code pays : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Flexible(
                            child: Text(
                              ' ${bigtilt.countrycode}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Taille : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${bigtilt.taille}m',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Pack Marketing : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${bigtilt.pack_marketing ? 'Oui' : 'Non'}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Tapis : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${bigtilt.tapis}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Type de tapis : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${bigtilt.tapistype}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Transport : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ' ${bigtilt.transport_type}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              'Date d\'expedition actuelle :  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${datedexpeisString ? '${bigtilt.date_exp}' : '${DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(bigtilt.date_exp))}'}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Validation de l\'atelier pour la date d\'expédition',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: bigtilt.date_valid,
                            onChanged: (atleiervalid) {
                              logsaving('Validation date d\'exp',
                                  bigtilt.id.toString());
                              if (atleiervalid == true)
                                bigtiltsInstance
                                    .doc(bigtilt.id.toString())
                                    .update({"date_valid": true});
                              else if (atleiervalid == false)
                                bigtiltsInstance
                                    .doc(bigtilt.id.toString())
                                    .update({"date_valid": false});
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
                    TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.blue,
                                    width: 5,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          setState(() {
                            infosSaved = true;
                          });
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
                      child: TextButton(
                        child: photo1
                            ? Text(
                                '',
                                style: TextStyle(),
                              )
                            : Icon(Icons.add_a_photo_outlined,
                                color: Colors.blue),
                        style:
                            TextButton.styleFrom(padding: EdgeInsets.all(20)),
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
                      child: TextButton(
                        child: photo2
                            ? Text(
                                '',
                                style: TextStyle(),
                              )
                            : Icon(Icons.add_a_photo_outlined,
                                color: Colors.blue),
                        style:
                            TextButton.styleFrom(padding: EdgeInsets.all(20)),
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
                      child: TextButton(
                        child: photo3
                            ? Text(
                                '',
                                style: TextStyle(),
                              )
                            : Icon(Icons.add_a_photo_outlined,
                                color: Colors.blue),
                        style:
                            TextButton.styleFrom(padding: EdgeInsets.all(20)),
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
