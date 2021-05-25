import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseBigtilts {
  final String uid;

  DatabaseBigtilts({this.uid});

  final CollectionReference bigtiltCollection =
      FirebaseFirestore.instance.collection("bigtilts");
  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveBigtilt(
      String uid,
      bool vendue,
      String chassit,
      String materiaux,
      // ignore: non_constant_identifier_names
      String deco_module,
      String plancher,
      String taille,
      String tapis,
      String tapistype,
      // ignore: non_constant_identifier_names
      String date_exp,
      // ignore: non_constant_identifier_names
      bool date_valid,
      // ignore: non_constant_identifier_names
      String transport_type,
      bool videoproj,
      // ignore: non_constant_identifier_names
      String videoproj_type) async {
    return await bigtiltCollection.doc(uid).set({
      'uid': uid,
      'Vendue': vendue,
      'Chassit': chassit,
      'Materiaux': materiaux,
      'deco_module': deco_module,
      'plancher': plancher,
      'taille': taille,
      'tapis': tapis,
      'Type tapis': tapistype,
      'date_exp': date_exp,
      'date_valid': date_valid,
      'transport_type': transport_type,
      'videoproj': videoproj,
      'videoproj_type': videoproj_type,
    });
  }

  AppBigTiltsData _bigtiltFromSnapshot(DocumentSnapshot snapshot) {
    return AppBigTiltsData(
      uid: snapshot.data()['uid'],
      vendue: snapshot.data()['Vendue'],
      chassit: snapshot.data()['Chassit'],
      materiaux: snapshot.data()['Materiaux'],
      deco_module: snapshot.data()['deco_module'],
      plancher: snapshot.data()['plancher'],
      taille: snapshot.data()['taille'],
      tapis: snapshot.data()['tapis'],
      tapistype: snapshot.data()['Type tapis'],
      date_exp: snapshot.data()['date_exp'],
      date_valid: snapshot.data()['date_valid'],
      transport_type: snapshot.data()['transport_type'],
      videoproj: snapshot.data()['videoproj'],
      videoproj_type: snapshot.data()['videoproj_type'],
    );
  }

  AppBigTilts _bigtiltFromfire(DocumentSnapshot snapshot) {
    return AppBigTilts(
      uid: snapshot.data()['uid'],
    );
  }

  Stream<AppBigTiltsData> get bigtilt {
    return bigtiltCollection.doc(uid).snapshots().map(_bigtiltFromSnapshot);
  }

  Stream<AppBigTilts> get bigtiltuid {
    return bigtiltCollection.doc(uid).snapshots().map(_bigtiltFromfire);
  }

  List<AppBigTiltsData> _bigtiltListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _bigtiltFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppBigTiltsData>> get bigtilts {
    return bigtiltCollection.snapshots().map(_bigtiltListFromSnapshot);
  }
}
