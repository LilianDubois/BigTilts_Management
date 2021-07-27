import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/Services/authentification.dart';
import 'package:bigtitlss_management/Services/database.dart';
import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_logs.dart';
import 'package:bigtitlss_management/Services/database_problems.dart';
import 'package:bigtitlss_management/Services/database_stock.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/logs.dart';
import 'package:bigtitlss_management/models/problems.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:bigtitlss_management/screen/splashscreen_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/stock.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// If you're going to use other Firebase services in the background, such as Firestore,
// make sure you call `initializeApp` before using other Firebase services.
// await Firebase.initializeApp();
  print('Background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<AppLogsData>>.value(
              value: DatabaseLogs().logslist, initialData: null),
          StreamProvider<AppUser>.value(
              value: AuthtificationService().user, initialData: null),
          StreamProvider<List<AppBigTiltsData>>.value(
              value: DatabaseBigtilts().bigtilts, initialData: null),
          StreamProvider<List<AppStockData>>.value(
              value: DatabaseStock().stocklist, initialData: null),
          StreamProvider<List<AppProblemsData>>.value(
              value: DatabaseProblems().problemslist, initialData: null),
          StreamProvider<List<AppUserData>>.value(
              value: DatabaseService().users, initialData: null),
          StreamProvider<AppBigTilts>.value(
              value: DatabaseBigtilts().bigtiltuid, initialData: null),
          StreamProvider<AppStock>.value(
              value: DatabaseStock().stockuid, initialData: null),
          StreamProvider<AppProblems>.value(
              value: DatabaseProblems().problemsuid, initialData: null),
          StreamProvider<AppLogs>.value(
              value: DatabaseLogs().logsuid, initialData: null),
        ],
        child: AdaptiveTheme(
          light: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),
          dark: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: Colors.black,
              cardColor: Colors.black),
          initial: AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => MaterialApp(
            home: SplashScreenWrapper(),
            theme: theme,
            darkTheme: darkTheme,
          ),
        ));
  }
}
