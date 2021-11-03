import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/stock.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseStock {
  final String uid;

  DatabaseStock({this.uid});

  final CollectionReference<Map<String, dynamic>> stockCollection =
      FirebaseFirestore.instance.collection("stock");
  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveStock(
      String uid,
      String name,
      String quantity_500_200,
      String quantity_400_200,
      String quantity_300_200,
      String real_quantity) async {
    return await stockCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'quantity_500_200': quantity_500_200,
      'quantity_400_200': quantity_400_200,
      'quantity_300_200': quantity_300_200,
      'real_quantity': real_quantity,
    });
  }

  AppStockData _stockFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppStockData(
      uid: snapshot.data()['uid'],
      name: snapshot.data()['name'],
      quantity_500_200: snapshot.data()['quantity_500_200'],
      quantity_400_200: snapshot.data()['quantity_400_200'],
      quantity_300_200: snapshot.data()['quantity_300_200'],
      real_quantity: snapshot.data()['real_quantity'],
    );
  }

  AppStock _stockFromfire(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppStock(
      uid: snapshot.data()['uid'],
    );
  }

  Stream<AppStockData> get stock {
    return stockCollection.doc(uid).snapshots().map(_stockFromSnapshot);
  }

  Stream<AppStock> get stockuid {
    return stockCollection.doc(uid).snapshots().map(_stockFromfire);
  }

  List<AppStockData> _stockListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _stockFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppStockData>> get stocklist {
    return stockCollection.snapshots().map(_stockListFromSnapshot);
  }
}
