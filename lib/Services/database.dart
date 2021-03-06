import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");
  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveUser(String name, int state) async {
    return await userCollection
        .doc(uid)
        .set({'uid': uid, 'name': name, 'State': state});
  }

  Future<void> saveToken(String token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  AppUserData _userFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppUserData(
      uid: snapshot.data()['uid'],
      name: snapshot.data()['name'],
      state: snapshot.data()['State'],
    );
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  List<AppUserData> _userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppUserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
