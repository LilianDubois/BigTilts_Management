import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';

import 'home/home_screen.dart';

class BugReport extends StatefulWidget {
  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  bool darkmode = false;
  dynamic savedThemeMode;
  TextEditingController editingController = TextEditingController();
  final descriptionController = TextEditingController();
  final solutionController = TextEditingController();
  var firebaseUser = FirebaseAuth.instance.currentUser;

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
    var options = new GmailSmtpOptions()
      ..username = 'l.dubois@wellputt.com'
      ..password = 'Lili@n1209';

    var emailTransport = new SmtpTransport(options);

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new HomeScreen()));
      },
    );

    AlertDialog alertBeugReport = AlertDialog(
      title: Text("Merci !"),
      content: Text("Email envoyé avec succès"),
      actions: [
        okButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Report'),
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
            height: 20,
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
            height: 120,
            child: Text(
                'Cette page a été crée pour que tout le monde puisse contribuer à l\'amélioration de l\'application. Vous pouvez ici soit signaler un beug, soit proposer une piste d\'amélioration qui vous semblerait une bonne innovation pour l\'application. Votre demande sera directement envoyée sur l\'adresse mail du developpeur'),
          ),
        ),
        SizedBox(height: 20.0),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text('Titre de votre remarque')),
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10),
              border: Border.all(
                  color: darkmode ? Colors.white : Colors.black, width: 4),
            ),
            child: Flexible(
              child: Container(
                child: new ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Objet de l\'email',
                    ),
                    maxLines: null,
                  ),
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
              child: Text('Description détaillé de votre remarque')),
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
                child: new ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: TextField(
                    controller: solutionController,
                    decoration: InputDecoration(
                      hintText: 'Corps du mail',
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        FlatButton(
          child: Text(
            'Envoyer ma remarque',
            style: TextStyle(),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.blue, width: 5, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(50)),
          padding: EdgeInsets.all(20),
          onPressed: () {
            var envelope = new Envelope()
              ..from = 'l.dubois@wellputt.com'
              ..recipients.add('liliandubois1209@gmail.com')
              ..bccRecipients.add('liliandubois1209@gmail.com')
              ..subject = descriptionController.text
              ..text =
                  '${firebaseUser.email} A envoyé : ${solutionController.text}';
            emailTransport.send(envelope).then((envelope) {
              showDialog(
                context: context,
                builder: (_) {
                  return alertBeugReport;
                },
                barrierDismissible: true,
              );
            }).catchError((e) => print('Error occurred: $e'));
          },
        ),
      ]))),
    );
  }
}
