import 'package:flutter/material.dart';

class BadVersion extends StatelessWidget {
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
            SizedBox(
              height: 100,
            ),
            Text(
              'Attention !',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Votre application n\'est pas a jour, Pour les utilisateurs d\'iphone merci de vous rendre dans TestFlight et de cliquer sur mettre a jour. Pour les autres merci de se renseigner auprès du développeur',
              style: TextStyle(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 150,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
