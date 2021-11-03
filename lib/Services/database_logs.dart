import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/logs.dart';

import 'package:firebase_auth/firebase_auth.dart';

class DatabaseLogs {
  final String uid;

  DatabaseLogs({this.uid});

  final CollectionReference<Map<String, dynamic>> logsCollection =
      FirebaseFirestore.instance.collection("logs");
  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveLogs(String uid, String name, String action, String date,
      String relatedElementUid) async {
    return await logsCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'action': action,
      'date': date,
      'relatedElementUid': relatedElementUid
    });
  }

  AppLogsData _logsFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppLogsData(
      uid: snapshot.data()['uid'],
      name: snapshot.data()['name'],
      action: snapshot.data()['action'],
      date: snapshot.data()['date'],
      relatedElementUid: snapshot.data()['relatedElementUid'],
    );
  }

  AppLogs _logsFromfire(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppLogs(
      uid: snapshot.data()['uid'],
    );
  }

  Stream<AppLogsData> get logs {
    return logsCollection.doc(uid).snapshots().map(_logsFromSnapshot);
  }

  Stream<AppLogs> get logsuid {
    return logsCollection.doc(uid).snapshots().map(_logsFromfire);
  }

  List<AppLogsData> _logsListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _logsFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppLogsData>> get logslist {
    return logsCollection
        .orderBy("date", descending: true)
        .snapshots()
        .map(_logsListFromSnapshot);
  }
}
