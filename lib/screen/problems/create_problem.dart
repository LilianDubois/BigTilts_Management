import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:bigtitlss_management/Services/database_problems.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/problems.dart';

import 'package:bigtitlss_management/screen/problems/problems_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateProblemScreen extends StatefulWidget {
  @override
  _CreateProblemScreenState createState() => _CreateProblemScreenState();
}

class _CreateProblemScreenState extends State<CreateProblemScreen> {
  final databaseProblems = DatabaseProblems();
  String _selectedindex;
  bool darkmode = false;
  dynamic savedThemeMode;
  final descriptionController = TextEditingController();
  final solutionController = TextEditingController();
  bool piecejointe = false;
  String fileurl;
  File filename;

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

  File file;
  @override
  Widget build(BuildContext context) {
    //final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    // int bigtiltscount = bigtiltlist.length;
    // AppBigTiltsData bigtilts;

    final bigtils = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final problems = Provider.of<List<AppProblemsData>>(context) ?? [];
    var index = bigtils.length;

    final List<String> uids = <String>[];

    afficher() {
      for (var i = 0; i < index; i++) {
        var _uid = bigtils[i].id;
        uids.add(_uid.toString());
      }
    }

    afficher();

    initializeDateFormatting('fr_FR', null);
    var now = DateTime.now();
    var datenow = DateFormat.yMMMd('fr_FR').format(now);

    var indexid = problems.length + 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Nouvel element'),
        elevation: 0.0,
      ),
      body: Container(
          //decoration: new BoxDecoration(color: Colors.black),
          child: SingleChildScrollView(
              child: Column(children: [
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
                  color: darkmode ? Colors.white : Colors.black, width: 4),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('BigTilt concernée'),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      // isExpanded: true,
                      dropdownColor: Colors.grey,
                      value: _selectedindex,

                      onChanged: (value) => setState(() {
                        _selectedindex = value;
                      }),
                      items: uids
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
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text('Description du problème rencontré :')),
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
            height: 200,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10),
              border: Border.all(
                  color: darkmode ? Colors.white : Colors.black, width: 4),
            ),
            child: Container(
              child: new ConstrainedBox(
                constraints: BoxConstraints(),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
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
          child: Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text('Solution trouvée au problème rencontré :')),
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
            height: 200,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10),
              border: Border.all(
                  color: darkmode ? Colors.white : Colors.black, width: 4),
            ),
            child: Container(
              child: new ConstrainedBox(
                constraints: BoxConstraints(),
                child: TextField(
                  controller: solutionController,
                  decoration: InputDecoration(
                    hintText: 'Solution',
                  ),
                  maxLines: null,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        FlatButton(
          child: Text(
            'Ajouter une pièce jointe',
            style: TextStyle(),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.blue, width: 5, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(50)),
          padding: EdgeInsets.all(20),
          onPressed: () {
            selectFile();
          },
        ),
        if (piecejointe) SizedBox(height: 30.0),
        if (piecejointe)
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text('Fichier importé :$filename')),
          ),
        SizedBox(height: 30.0),
        FlatButton(
          child: Text(
            'Enregistrer le problème',
            style: TextStyle(),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.blue, width: 5, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(50)),
          padding: EdgeInsets.all(20),
          onPressed: () {
            uploadFile() async {
              indexid = (indexid + 1);
              FirebaseStorage storage = FirebaseStorage.instance;
              Reference ref = storage
                  .ref()
                  .child('Problem_BT${_selectedindex}_${indexid}file');
              UploadTask uploadTask = ref.putFile(file);
              uploadTask.then((res) {
                fileurl = (res.ref.getDownloadURL()).toString();
              });
            }

            uploadFile();

            databaseProblems.saveProblems(
              // ignore: unnecessary_brace_in_string_interps
              'Problem_BT${_selectedindex}_${indexid}',
              'BigTilt N°$_selectedindex',
              descriptionController.text,
              solutionController.text,
              datenow,
              datenow,
              filename.toString(),
            );
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new Problems_Screen()));
          },
        ),
        SizedBox(height: 100.0),
      ]))),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }

    if (result == null) return;
    final path = result.files.single.path;
    final pathh = result.files.single.name;
    setState(() {
      file = File(path);
      filename = File(pathh);
      piecejointe = true;
    });
    setState(() => file = File(path));
  }
}
