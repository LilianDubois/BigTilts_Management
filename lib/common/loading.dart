import 'package:bigtitlss_management/Services/authentification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final AuthtificationService _auth = AuthtificationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            SpinKitRipple(
              color: Colors.blue,
              size: 60.0,
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              'Chargement en cours ... Patience !',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Si le chargement perciste veuillez vous deconnecter, puis resssayer',
              style: TextStyle(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 150,
            ),
            FlatButton(
              child: Text(
                'Se deconnecter',
                style: TextStyle(color: Colors.black),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.blue, width: 5, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.all(20),
              onPressed: () async {
                await _auth.signout();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Ou peut-etre que c\est cassé ...',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            Text(
              'Dans ce cas il faut relancer l\'appli COMPLETEMENT',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            Text(
              'Completement ça veux dire l\'enlever des taches de fond ;)',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
