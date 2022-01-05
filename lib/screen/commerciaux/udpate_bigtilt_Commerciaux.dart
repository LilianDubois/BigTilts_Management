import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/bigtilts_stock.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/pdf/pdf_api.dart';
import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:date_field/date_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateBigtiltCommerciaux extends StatefulWidget {
  var currentUid;
  var currentVendue;
  var currentNomclient;
  var currentChassit;
  var currentMateriaux;
  var currentPlancher;
  var currentDeco;
  var currentTaille;
  var currentTapis;
  var currentSubTapis;
  var currentPackMarteting;
  var currentTransport;
  var currentDateAtelier;
  var currentDateExp;
  var currentDateValid;
  var currentVideoProj;
  var currentTypeVideoProj;
  var currentarchived;
  var infos;
  var expediee;
  UpdateBigtiltCommerciaux(
      this.currentUid,
      this.currentVendue,
      this.currentNomclient,
      this.currentChassit,
      this.currentMateriaux,
      this.currentPlancher,
      this.currentDeco,
      this.currentTaille,
      this.currentTapis,
      this.currentSubTapis,
      this.currentPackMarteting,
      this.currentTransport,
      this.currentDateAtelier,
      this.currentDateExp,
      this.currentDateValid,
      this.currentVideoProj,
      this.currentTypeVideoProj,
      this.currentarchived,
      this.infos,
      this.expediee);

  @override
  _UpdateBigtiltCommerciauxState createState() =>
      _UpdateBigtiltCommerciauxState(
        this.currentUid,
        this.currentVendue,
        this.currentNomclient,
        this.currentChassit,
        this.currentMateriaux,
        this.currentPlancher,
        this.currentDeco,
        this.currentTaille,
        this.currentTapis,
        this.currentSubTapis,
        this.currentPackMarteting,
        this.currentTransport,
        this.currentDateAtelier,
        this.currentDateExp,
        this.currentDateValid,
        this.currentVideoProj,
        this.currentTypeVideoProj,
        this.currentarchived,
        this.infos,
      );
}

class _UpdateBigtiltCommerciauxState extends State<UpdateBigtiltCommerciaux> {
  _UpdateBigtiltCommerciauxState(
      var _currentUid,
      var _currentVendue,
      var _currentNomClient,
      var _currentChassit,
      var _currentMateriaux,
      var _currentPlancher,
      var _currentDeco,
      var _currentTaille,
      var _currentTapis,
      var _currentSubTapis,
      var _currentPackMarketing,
      var _currentTransport,
      var _currentDateAtelier,
      var _currentDateExp,
      var _currentDateValid,
      var _currentVideoProj,
      var _currentTypeVideoProj,
      var _currentarchived,
      var _currentinfos) {
    this.vendue = _currentVendue;
    this._selectedNomclient = _currentNomClient;
    this._selectedindex = _currentChassit;
    this._selectedmateriaux = _currentMateriaux;
    this._selectedPlancher = _currentPlancher;
    this._selectedDeco = _currentDeco;
    this._selectedTaille = _currentTaille;
    this._oldSelectedTaille = _currentTaille;
    this._selectedTapis = _currentTapis;
    this._selectedTapissub = _currentSubTapis;
    this._selectedPackMarketing = _currentPackMarketing;
    this._selectedTransport = _currentTransport;
    this.date_atelier = _currentDateAtelier;
    this.dateexp = _currentDateExp;
    this.atleiervalid = _currentDateValid;
    this.videoproj = _currentVideoProj;
    this._selectedTypevideo = _currentTypeVideoProj;
    this._selectedArchived = _currentarchived;
    this._selectedInfos = _currentinfos;
  }

  final database = DatabaseBigtilts();
  final databasestock = DatabaseStock();
  final databaselogs = DatabaseLogs();

  final numController = TextEditingController();
  final infosController = TextEditingController();

  bool vendue = false;
  String _selectedindex;
  bool darkmode = false;
  dynamic savedThemeMode;
  String colorBorder;

  String _selectedNomclient;
  String _selectedmateriaux;
  String _selectedPlancher;
  String _selectedDeco;
  String _selectedTaille;
  String _oldSelectedTaille;
  String _selectedTapis;
  String _selectedTapissub;
  String _selectedTransport;
  String dateexp = 'Non renseignée';
  String date_atelier = 'Non renseignée';
  bool atleiervalid = false;
  bool videoproj = false;
  String _selectedTypevideo;
  bool _selectedArchived;
  bool _selectedPackMarketing;
  String _selectedInfos;

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
    AppUserData user;

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
      nomControllerval = widget.currentNomclient;
    }
    if (infosController.text != "") {
      infosControllerval = infosController.text;
    } else {
      infosControllerval = widget.infos;
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
        DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(date_atelier));
      } on Exception catch (_) {
        dateatelierisString = true;
      }
      try {
        DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(dateexp));
      } on Exception catch (_) {
        datedexpeisString = true;
      }
    }

    textString();

    Future<void> updateDate() {
      databaselogs.saveLogs(
          '${DateTime.now().toString()}',
          user.name,
          'a modifié la taille de la bigtilt ${widget.currentUid}',
          DateTime.now().toString(),
          widget.currentUid.toString());
      if (_oldSelectedTaille == '4 * 200' && _selectedTaille == '5 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity1 = int.parse(stock[i].real_quantity) +
              int.parse(stock[i].quantity_400_200) -
              int.parse(stock[i].quantity_500_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity1.toString());
        }
      }
      if (_oldSelectedTaille == '4 * 200' && _selectedTaille == '3 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity2 = int.parse(stock[i].real_quantity) +
              int.parse(stock[i].quantity_400_200) -
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
      if (_oldSelectedTaille == '5 * 200' && _selectedTaille == '3 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity3 = int.parse(stock[i].real_quantity) +
              int.parse(stock[i].quantity_500_200) -
              int.parse(stock[i].quantity_300_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity3.toString());
        }
      }
      if (_oldSelectedTaille == '5 * 200' && _selectedTaille == '4 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity4 = int.parse(stock[i].real_quantity) +
              int.parse(stock[i].quantity_500_200) -
              int.parse(stock[i].quantity_400_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity4.toString());
        }
      }
      if (_oldSelectedTaille == '3 * 200' && _selectedTaille == '4 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity5 = int.parse(stock[i].real_quantity) +
              int.parse(stock[i].quantity_300_200) -
              int.parse(stock[i].quantity_400_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity5.toString());
        }
      }
      if (_oldSelectedTaille == '3 * 200' && _selectedTaille == '5 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity6 = int.parse(stock[i].real_quantity) +
              int.parse(stock[i].quantity_300_200) -
              int.parse(stock[i].quantity_500_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity6.toString());
        }
      }
      if (_oldSelectedTaille == '-' && _selectedTaille == '3 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity6 = int.parse(stock[i].real_quantity) -
              int.parse(stock[i].quantity_300_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity6.toString());
        }
      }
      if (_oldSelectedTaille == '-' && _selectedTaille == '4 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity6 = int.parse(stock[i].real_quantity) -
              int.parse(stock[i].quantity_400_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity6.toString());
        }
      }
      if (_oldSelectedTaille == '-' && _selectedTaille == '5 * 200') {
        for (var i = 0; i < 1; i++) {
          int realquantity6 = int.parse(stock[i].real_quantity) -
              int.parse(stock[i].quantity_500_200);
          databasestock.saveStock(
              stock[i].uid,
              stock[i].name,
              stock[i].quantity_500_200,
              stock[i].quantity_400_200,
              stock[i].quantity_300_200,
              realquantity6.toString());
        }
      }

      print(_oldSelectedTaille);
      database.saveBigtilt(
          widget.currentUid,
          vendue,
          nomController.text,
          _selectedindex,
          _selectedmateriaux,
          _selectedDeco,
          _selectedPlancher,
          _selectedTaille,
          _selectedTapis,
          _selectedTapissub,
          _selectedPackMarketing,
          date_atelier,
          dateexp,
          atleiervalid,
          _selectedTransport,
          videoproj,
          _selectedTypevideo,
          _selectedArchived,
          infosController.text,
          widget.expediee);

      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new HomeScreen()));
    }

    Widget okButtonUp = FlatButton(
      child: Text("Oui"),
      onPressed: () {
        updateDate();
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new HomeScreen()));
      },
    );

    Widget nonButtonUp = FlatButton(
      child: Text("Non"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alertUp = AlertDialog(
      title: Text("Attention"),
      content: Text(
          "Vous allez modifier la taille de cette BigTilt. Le stock va etre modifié en conséquence. Voulez vous continuer ?"),
      actions: [
        okButtonUp,
        nonButtonUp,
      ],
    );

    Widget okButtonSuppr = FlatButton(
      child: Text("Oui"),
      onPressed: () {
        if (_selectedArchived) {
          _selectedArchived = false;
          databaselogs.saveLogs(
              '${DateTime.now().toString()}',
              user.name,
              'a desarchivé la bigtilt ${widget.currentUid}',
              DateTime.now().toString(),
              widget.currentUid.toString());
        } else {
          _selectedArchived = true;
          databaselogs.saveLogs(
              '${DateTime.now().toString()}',
              user.name,
              'a archivé la bigtilt ${widget.currentUid}',
              DateTime.now().toString(),
              widget.currentUid.toString());
        }
        database.saveBigtilt(
            widget.currentUid,
            widget.currentVendue,
            widget.currentNomclient,
            widget.currentChassit,
            widget.currentMateriaux,
            widget.currentDeco,
            widget.currentPlancher,
            widget.currentPlancher,
            widget.currentTapis,
            widget.currentSubTapis,
            widget.currentPackMarteting,
            widget.currentDateAtelier,
            widget.currentDateExp,
            widget.currentDateValid,
            widget.currentTransport,
            widget.currentVideoProj,
            widget.currentTypeVideoProj,
            _selectedArchived,
            widget.infos,
            widget.expediee);
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new HomeScreen()));
      },
    );

    Widget nonButtonSuppr = FlatButton(
      child: Text("Non"),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new HomeScreen()));
      },
    );

    AlertDialog alertSuppr = AlertDialog(
      title: Text("Attention"),
      content: _selectedArchived
          ? Text(
              "Voulez vous vraiment enlever la BigTilt n°${widget.currentUid} des archives ?")
          : Text(
              "Voulez vous vraiment archiver la BigTilt n°${widget.currentUid}"),
      actions: [
        okButtonSuppr,
        nonButtonSuppr,
      ],
    );

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
                  height: 70,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nom du client :'),
                        Flexible(
                            child: Container(
                          child: TextField(
                            controller: nomController,
                            decoration: InputDecoration(
                              hintText: 'Nom',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              nomControllerval = value;
                            },
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
                          'Type de chassis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

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
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Matériaux modules',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

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
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Plancher',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

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
                          width: 4)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Décoration modules',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,

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
                    borderRadius:
                        new BorderRadius.vertical(top: Radius.circular(10)),
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vidéo projecteur',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
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
                      borderRadius: new BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                      border: Border.all(
                          color: darkmode ? Colors.white : Colors.black,
                          width: 4),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              // isExpanded: true,

                              value: _selectedTypevideo,

                              items: videotypeitems
                                  .map((item) => DropdownMenuItem(
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
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
                            value: _selectedPackMarketing,
                            onChanged: (bool newval) {
                              setState(() {
                                _selectedPackMarketing = newval;
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
                        Text(dateatelierisString
                            ? 'Date de sortie d\'atelier : $date_atelier'
                            : 'Date de sortie d\'atelier : ${DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(date_atelier))}'),
                      ]),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 100,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: darkmode ? Colors.white : Colors.black,
                        width: 4),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Date d\'expé ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Actuelle :',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              datedexpeisString
                                  ? '$dateexp'
                                  : '${DateFormat('d MMMM y', 'fr_FR').format(DateTime.parse(dateexp))}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(
                            width: 150,
                            child: DateTimeFormField(
                              dateTextStyle: TextStyle(
                                color: darkmode ? Colors.white : Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: darkmode ? Colors.white : Colors.black,
                                ),
                                errorStyle: TextStyle(
                                  color: darkmode ? Colors.white : Colors.black,
                                ),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.event_note,
                                ),
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
              if (_oldSelectedTaille != _selectedTaille) SizedBox(height: 20.0),
              if (_oldSelectedTaille != _selectedTaille)
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
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: GestureDetector(
                  onTap: () async {
                    final pdfFile = await PdfApi.generateCenteredText(
                        '${widget.currentUid}',
                        nomController.text,
                        _selectedindex,
                        _selectedmateriaux,
                        _selectedPlancher,
                        _selectedDeco,
                        _selectedTaille,
                        _selectedTapis,
                        _selectedTapissub,
                        _selectedPackMarketing,
                        _selectedTransport,
                        dateexp,
                        videoproj,
                        _selectedTypevideo,
                        infosController.text);

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
              _selectedArchived
                  ? SizedBox(height: 0.0)
                  : FlatButton(
                      child: Text(
                        'Modifier la BigTilt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue,
                              width: 5,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(20),
                      onPressed: () {
                        databaselogs.saveLogs(
                            '${DateTime.now().toString()}',
                            user.name,
                            'a modifié la bigtilt ${widget.currentUid}',
                            DateTime.now().toString(),
                            widget.currentUid.toString());
                        if (_oldSelectedTaille != _selectedTaille) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return alertUp;
                            },
                            barrierDismissible: true,
                          );
                        } else {
                          print(_oldSelectedTaille);
                          database.saveBigtilt(
                              widget.currentUid,
                              vendue,
                              nomController.text,
                              _selectedindex,
                              _selectedmateriaux,
                              _selectedDeco,
                              _selectedPlancher,
                              _selectedTaille,
                              _selectedTapis,
                              _selectedTapissub,
                              _selectedPackMarketing,
                              date_atelier,
                              dateexp,
                              atleiervalid,
                              _selectedTransport,
                              videoproj,
                              _selectedTypevideo,
                              _selectedArchived,
                              infosController.text,
                              widget.expediee);

                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new HomeScreen()));
                        }
                      },
                    ),
              SizedBox(height: 30.0),
              FlatButton(
                child: _selectedArchived
                    ? Text(
                        'Désarchiver la BigTilt',
                        style: TextStyle(),
                      )
                    : Text(
                        'archiver la BigTilt',
                        style: TextStyle(),
                      ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.red, width: 5, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.all(20),
                onPressed: () {
                  print(_selectedArchived);
                  showDialog(
                    context: context,
                    builder: (_) {
                      return alertSuppr;
                    },
                    barrierDismissible: true,
                  );
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
