import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/problems.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseProblems {
  final String uid;

  DatabaseProblems({this.uid});

  final CollectionReference<Map<String, dynamic>> problemsCollection =
      FirebaseFirestore.instance.collection("problems");
  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveProblems(
    String uid,
    String bigtilt,
    String problem_description,
    String problem_solution,
    String date_maj,
    String date_create,
    String file_url,
  ) async {
    return await problemsCollection.doc(uid).set({
      'uid': uid,
      'bigtilt': bigtilt,
      'problem_description': problem_description,
      'problem_solution': problem_solution,
      'date_maj': date_maj,
      'date_create': date_create,
      'file_url': file_url
    });
  }

  AppProblemsData _problemsFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppProblemsData(
        uid: snapshot.data()['uid'],
        bigtilt: snapshot.data()['bigtilt'],
        problem_description: snapshot.data()['problem_description'],
        problem_solution: snapshot.data()['problem_solution'],
        date_maj: snapshot.data()['date_maj'],
        date_create: snapshot.data()['date_create'],
        file_url: snapshot.data()['file_url']);
  }

  AppProblems _problemsFromfire(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppProblems(
      uid: snapshot.data()['uid'],
    );
  }

  Stream<AppProblemsData> get problems {
    return problemsCollection.doc(uid).snapshots().map(_problemsFromSnapshot);
  }

  Stream<AppProblems> get problemsuid {
    return problemsCollection.doc(uid).snapshots().map(_problemsFromfire);
  }

  List<AppProblemsData> _problemsListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _problemsFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppProblemsData>> get problemslist {
    return problemsCollection.snapshots().map(_problemsListFromSnapshot);
  }
}
