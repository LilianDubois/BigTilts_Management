import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseBigtilts {
  final String uid;

  DatabaseBigtilts({this.uid});

  final CollectionReference<Map<String, dynamic>> bigtiltCollection =
      FirebaseFirestore.instance.collection("bigtilts");
  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveBigtilt(
      int uid,
      bool vendue,
      String nomclient,
      String chassit,
      String materiaux,
      // ignore: non_constant_identifier_names
      String deco_module,
      String plancher,
      String taille,
      String tapis,
      String tapistype,
      bool pack_marketing,
      // ignore: non_constant_identifier_names
      String date_atelier,
      String date_exp,
      // ignore: non_constant_identifier_names
      bool date_valid,
      // ignore: non_constant_identifier_names

      String transport_type,
      bool videoproj,
      // ignore: non_constant_identifier_names
      String videoproj_type,
      bool archived,
      String infos,
      bool expediee) async {
    return await bigtiltCollection.doc(uid.toString()).set({
      'id': uid,
      'Vendue': vendue,
      'nomclient': nomclient,
      'Chassit': chassit,
      'Materiaux': materiaux,
      'deco_module': deco_module,
      'plancher': plancher,
      'taille': taille,
      'tapis': tapis,
      'Type tapis': tapistype,
      'pack_marketing': pack_marketing,
      'date_atelier': date_atelier,
      'date_exp': date_exp,
      'date_valid': date_valid,
      'transport_type': transport_type,
      'videoproj': videoproj,
      'videoproj_type': videoproj_type,
      'archived': archived,
      'infos': infos,
      'expediee': expediee
    });
  }

  AppBigTiltsData _bigtiltFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppBigTiltsData(
      id: snapshot.data()['id'],
      vendue: snapshot.data()['Vendue'],
      nomclient: snapshot.data()['nomclient'],
      chassit: snapshot.data()['Chassit'],
      materiaux: snapshot.data()['Materiaux'],
      deco_module: snapshot.data()['deco_module'],
      plancher: snapshot.data()['plancher'],
      taille: snapshot.data()['taille'],
      tapis: snapshot.data()['tapis'],
      tapistype: snapshot.data()['Type tapis'],
      pack_marketing: snapshot.data()['pack_marketing'],
      date_atelier: snapshot.data()['date_atelier'],
      date_exp: snapshot.data()['date_exp'],
      date_valid: snapshot.data()['date_valid'],
      transport_type: snapshot.data()['transport_type'],
      videoproj: snapshot.data()['videoproj'],
      videoproj_type: snapshot.data()['videoproj_type'],
      archived: snapshot.data()['archived'],
      infos: snapshot.data()['infos'],
      expediee: snapshot.data()['expediee'],
    );
  }

  AppBigTilts _bigtiltFromfire(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
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

  List<AppBigTiltsData> _bigtiltListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _bigtiltFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppBigTiltsData>> get bigtilts {
    return bigtiltCollection
        .orderBy("id", descending: true)
        .snapshots()
        .map(_bigtiltListFromSnapshot);
  }
}
