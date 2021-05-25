import 'package:bigtitlss_management/Services/authentification.dart';
import 'package:bigtitlss_management/Services/database.dart';
import 'package:bigtitlss_management/main.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/Stock/stock_screen.dart';
import 'package:bigtitlss_management/screen/admin/admin_users.dart';
import 'package:bigtitlss_management/screen/authentificate/authentificate_screen.dart';
import 'package:bigtitlss_management/screen/bugReport.dart';
import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:bigtitlss_management/screen/problems/problems_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  final AuthtificationService _auth = AuthtificationService();

  bool darkmode = false;
  dynamic savedThemeMode;

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
    final Color background = Colors.black;
    final Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 90.23; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    final users = Provider.of<List<AppUserData>>(context);

    // var firebaseUser = FirebaseAuth.instance.currentUser;
    AppUserData user;

    var index = 0;
    while (users[index].uid != firebaseUser.uid) {
      index++;
    }
    user = users[index];

    switchWithString() {
      switch (users[index].state) {
        case 1:
          return 'Administrateur';
          break;

        case 2:
          return 'Atelier';
          break;

        case 3:
          return 'Commercial';
          break;

        case 4:
          return 'Dev';
          break;

        default:
          return 'invité';
      }
    }

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            stops: stops,
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          ),
        ),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              margin: EdgeInsets.only(bottom: 0.0),
              decoration: BoxDecoration(color: Colors.black),
              accountName: Text(
                user.name,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              accountEmail: new Text(
                switchWithString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/img/logo_wellputt.png")),
            ),
            if (user.state == 3 ||
                user.state == 1 ||
                user.state == 2 ||
                user.state == 4)
              new ListTile(
                  leading:
                      new Icon(Icons.golf_course_outlined, color: Colors.black),
                  title: new Text('Bigtilts',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Spaceage')),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new HomeScreen()));
                  }),
            if (user.state == 1)
              new ListTile(
                  leading: new Icon(Icons.accessibility_new_outlined,
                      color: Colors.black),
                  title: new Text('Utilisateurs',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Spaceage')),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new UserAdminScreen()));
                  }),
            if (user.state == 2 ||
                user.state == 3 ||
                user.state == 1 ||
                user.state == 4)
              new ListTile(
                  leading: new Icon(Icons.inventory, color: Colors.black),
                  title: new Text('Stock',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Spaceage')),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StockScreen()));
                  }),
            if (user.state != 0)
              new ListTile(
                  leading: new Icon(Icons.report_problem_outlined,
                      color: Colors.black),
                  title: new Text('Problèmes',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Spaceage')),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new Problems_Screen()));
                  }),
            SizedBox(height: 100),
            new ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: new Text('Se déconnecter',
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut().then((res) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  });
                  _auth.signout();
                }),
            new SwitchListTile(
                activeColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey,
                title: new Text('Dark mode',
                    style: TextStyle(color: Colors.black)),
                value: darkmode,
                onChanged: (bool value) {
                  if (value == true) {
                    AdaptiveTheme.of(context).setDark();

                    // darkmode = value;
                  } else {
                    AdaptiveTheme.of(context).setLight();
                    //value = value;

                  }
                  setState(() {
                    darkmode = value;
                  });
                }),
            if (user.state != 0)
              new ListTile(
                leading: Icon(
                  Icons.bug_report_outlined,
                  color: Colors.black,
                ),
                title:
                    new Text('Report', style: TextStyle(color: Colors.black)),
                onTap: () async {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new BugReport()));
                },
              ),
          ],
        ),
      ),
    );
  }
}
