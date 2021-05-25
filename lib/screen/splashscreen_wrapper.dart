import 'package:flutter/material.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/authentificate/authentificate_screen.dart';
import 'package:bigtitlss_management/screen/home/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    if (user == null) {
      return AuthentificateScreen();
    } else {
      return HomeScreen();
    }
  }
}
