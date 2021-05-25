import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/database_problems.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/problems.dart';
import 'package:bigtitlss_management/screen/problems/problems_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateProblem extends StatefulWidget {
  var _uid;
  var _bigtilt;
  var _problem_description;
  var _problem_solution;
  var _date_maj;
  var _date_create;
  var _file_path;
  UpdateProblem(
      this._uid,
      this._bigtilt,
      this._problem_description,
      this._problem_solution,
      this._date_maj,
      this._date_create,
      this._file_path);

  @override
  _UpdateProblemState createState() => _UpdateProblemState(
      this._uid,
      this._bigtilt,
      this._problem_description,
      this._problem_solution,
      this._date_maj,
      this._date_create,
      this._file_path);
}

class _UpdateProblemState extends State<UpdateProblem> {
  _UpdateProblemState(
      var currentuid,
      var currentbigtilt,
      var currentproblem_description,
      var currentproblem_solution,
      var currentdate_maj,
      var currentdate_create,
      var currentfile_path) {
    this.uid = currentuid;
    this.bigtilt = currentbigtilt;
    this.problem_description = currentproblem_description;
    this.problem_solution = currentproblem_solution;
    this.date_maj = currentdate_maj;
    this.date_create = currentdate_create;
    this.file_path = currentfile_path;
  }

  String uid;
  String bigtilt;
  String problem_description;
  String problem_solution;
  String date_maj;
  String date_create;
  String file_path;
  var newbigtilt;
  String filepath;
  File file;
  String def;
  bool darkmode = false;
  bool piecejointe = false;
  dynamic savedThemeMode;
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

  Future<void> delete(String problemId) {
    return FirebaseFirestore.instance
        .collection('problems')
        .doc(problemId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseStorage storage = FirebaseStorage.instance;
    final bigtiltsuid = Provider.of<List<AppBigTiltsData>>(context) ?? [];
    final numController = TextEditingController();
    final descriptionController =
        TextEditingController(text: widget._problem_description);
    final solutionController =
        TextEditingController(text: widget._problem_solution);
    initializeDateFormatting('fr_FR', null);
    var now = DateTime.now();
    var datenow = DateFormat.yMMMd('fr_FR').format(now);
    final database = DatabaseProblems();

    var index = bigtiltsuid.length;

    final List<String> bigtiltslist = <String>[];

    afficher() {
      for (var i = 0; i < index; i++) {
        var _uid = bigtiltsuid[i].uid;
        bigtiltslist.add('BigTilt N°$_uid');
      }
    }

    afficher();

    return StreamProvider<List<AppProblemsData>>.value(
      initialData: [],
      value: database.problemslist,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('${widget._bigtilt} - problème'),
          elevation: 0.0,
        ),
        body: Container(
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
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text('Problème déclaré le $date_create')),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
                height: 30,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text('Dernière mise a jour : $date_maj')),
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
                        value: bigtilt,

                        onChanged: (value) => setState(() {
                          bigtilt = value;
                        }),
                        items: bigtiltslist
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
              child: Flexible(
                child: Container(
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
              child: Flexible(
                child: Container(
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
          if (file_path != 'null')
            FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 100,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            downloadURLExample();
                          },
                          child: Text(
                            '$file_path',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          )),
                      FlatButton(
                        child: Text(
                          'Modifier le fichier lié',
                          style: TextStyle(),
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.blue,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          selectFile();
                        },
                      ),
                    ],
                  ),
                )),
          SizedBox(height: 20.0),
          if (file_path == 'null')
            FlatButton(
              child: Text(
                'Enregistrer un fichier lié',
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
          if (file_path == 'null') SizedBox(height: 30.0),
          if (piecejointe)
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text('Fichier importé :$filename')),
            ),
          if (piecejointe) SizedBox(height: 30.0),
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
                FirebaseStorage storage = FirebaseStorage.instance;
                Reference ref = storage.ref().child('${uid}file');
                UploadTask uploadTask = ref.putFile(file);
                uploadTask.then((res) {
                  fileurl = (res.ref.getDownloadURL()).toString();
                });
              }

              uploadFile();
              DatabaseProblems().saveProblems(
                  '$uid',
                  '$bigtilt',
                  descriptionController.text,
                  solutionController.text,
                  datenow,
                  '$date_create',
                  filename.toString());
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new Problems_Screen()));
            },
          ),
          SizedBox(height: 30.0),
          FlatButton(
            child: Text(
              'Supprimer',
              style: TextStyle(),
            ),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.red, width: 5, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(20),
            onPressed: () {
              delete(uid);
              deletefile();
              Navigator.pop(context, true);
            },
          ),
          SizedBox(height: 100.0),
        ]))),
      ),
    );
  }

  downloadURLExample() async {
    filepath =
        await FirebaseStorage.instance.ref(uid + 'file').getDownloadURL();

    print('file : $filepath');
    await canLaunch(filepath)
        ? await launch(filepath)
        : throw 'Could not launch $filepath';
// Within your widgets:
// Image.network(downloadURL);
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

  deletefile() async {
    await FirebaseStorage.instance.ref(uid + 'file').delete();
  }
}
