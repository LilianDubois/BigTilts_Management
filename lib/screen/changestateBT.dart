import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeStateBT extends StatefulWidget {
  var Btuid;
  var state;
  ChangeStateBT(this.Btuid, this.state);

  @override
  _ChangeStateBTState createState() => _ChangeStateBTState();
}

class _ChangeStateBTState extends State<ChangeStateBT> {
  final databaselogs = DatabaseLogs();

  bool darkmode = false;
  String newstate = 'null';
  String text = 'null';
  bool stockUS = false;
  bool livre = false;

  void writenewstate() {
    print('nexstate');
    switch (widget.state) {
      case 'En stock US':
        newstate = 'Réservée';
        text = 'Voulez vous la Reserver ?';
        break;
      case 'Vendue US':
        newstate = 'Expédiée';
        text = 'A-t-elle été expédiée ?';
        break;
      case 'En stock FR':
        newstate = 'Réservée';
        text = 'Voulez vous la Reserver ?';
        break;
      case 'Expédiée':
        newstate = 'Livrée';
        text = 'A t-elle été livrée ?';
        break;
      case 'Expediée':
        newstate = 'Livrée';
        text = 'A t-elle été livrée ?';
        break;
      case 'Livrée':
        newstate = 'En place chez le client';
        text = 'Est elle en place chez le client ?';
        break;
      default:
        '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final users = Provider.of<List<AppUserData>>(context);
    AppUserData user;

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    user = users[index];

    Future<void> logsaving(String item, String id) async {
      databaselogs.saveLogs(
          '${DateTime.now().toString()}',
          user.name,
          'Changé l\'état de la bigtilt $id de ${widget.state} à $item',
          DateTime.now().toString(),
          widget.Btuid.toString());
    }

    writenewstate();

    final bigtiltsInstance = FirebaseFirestore.instance.collection("bigtilts");

    return Container(
        child: Column(
      children: [
        if (stockUS != true)
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              alignment: Alignment.center,
              height: 70,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius:
                      new BorderRadius.vertical(top: Radius.circular(10)),
                  border: Border.all(color: Colors.red, width: 3)),
              child: Text(
                'Cette bigtilt est ${widget.state} \n $text',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        if (stockUS != true)
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: new BoxDecoration(
                  borderRadius:
                      new BorderRadius.vertical(bottom: Radius.circular(10)),
                  border: Border.all(color: Colors.red, width: 3)),
              child: TextButton(
                onPressed: () {
                  if (widget.state != 'Expédiée' ||
                      widget.state != 'Expediée') {
                    logsaving(newstate, widget.Btuid.toString());
                    bigtiltsInstance
                        .doc(widget.Btuid.toString())
                        .update({"status": newstate});
                  }
                  if (widget.state == 'Expédiée' ||
                      widget.state == 'Expediée') {
                    setState(() {
                      stockUS = true;
                    });
                  }
                },
                child: Text(
                  "Oui",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        if (stockUS == true)
          Column(children: [
            SizedBox(
              height: 20,
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                alignment: Alignment.center,
                height: 70,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.vertical(top: Radius.circular(10)),
                    border: Border.all(color: Colors.red, width: 3)),
                child: Text(
                  'Cette bigtilt est destinée au stock au US ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10)),
                          border: Border.all(color: Colors.red, width: 3)),
                      child: TextButton(
                        onPressed: () {
                          logsaving('En stock US', widget.Btuid.toString());
                          bigtiltsInstance.doc(widget.Btuid.toString()).update({
                            "status": 'En stock US',
                            "date_exp": 'Non renseignée'
                          });
                          stockUS = false;
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Oui",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                          border: Border.all(color: Colors.red, width: 3)),
                      child: TextButton(
                        onPressed: () {
                          logsaving('Livrée', widget.Btuid.toString());
                          bigtiltsInstance
                              .doc(widget.Btuid.toString())
                              .update({"status": 'Livrée'});
                          stockUS = false;
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Non",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        SizedBox(height: 20)
      ],
    ));
  }
}
