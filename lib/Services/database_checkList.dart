import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bigtitlss_management/models/checkLists.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseCheckLists {
  final String uid;

  DatabaseCheckLists({this.uid});

  final CollectionReference<Map<String, dynamic>> checkListCollection =
      FirebaseFirestore.instance.collection("checkLists");

  final firestoreInstance = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> saveCheckList(
      int uid,
      int palette,
      int caisse,
      int taillebt,
      bool planchers,
      bool tapisWP,
      bool check1,
      bool check2,
      String check1user,
      String check2user) async {
    return await checkListCollection.doc(uid.toString()).set({
      'id': uid,
      'palette': palette,
      'caisse': caisse,
      'taillebt': taillebt,
      'planchers': planchers,
      'tapisWP': tapisWP,
      'check1': check1,
      'check2': check2,
      'check1user': check1user,
      'check2user': check2user,
    });
  }

  Future<void> saveCheckListCartons(
    String carton,
    int uid,
    bool modulesVerinsLateraux,
    bool cableinterverins,
    bool modulesVerinsangles,
    bool modulesIntermediaires,
    bool moduleslaterauxback,
    bool moduleslaterauxfront,
    bool calesbois,
  ) async {
    final CollectionReference<Map<String, dynamic>> cartonscollection =
        FirebaseFirestore.instance
            .collection("checkLists")
            .doc(uid.toString())
            .collection('Checklist' + uid.toString());

    if (carton == 'all') {
      await cartonscollection.doc('Carton1').set({
        'modulesVerinsLateraux': modulesVerinsLateraux,
        'cableinterverins': cableinterverins,
      });
      await cartonscollection.doc('Carton2').set({
        'modulesVerinsLateraux': modulesVerinsLateraux,
      });
      await cartonscollection.doc('Carton3').set({
        'modulesVerinsLateraux': modulesVerinsLateraux,
      });
      await cartonscollection.doc('Carton4').set({
        'modulesVerinsLateraux': modulesVerinsLateraux,
      });
      await cartonscollection.doc('Carton5').set({
        'modulesVerinsangles': modulesVerinsangles,
      });
      await cartonscollection.doc('Carton6').set({
        'modulesVerinsangles': modulesVerinsangles,
      });
      await cartonscollection.doc('Carton7').set({
        'modulesIntermediaires': modulesIntermediaires,
      });
      await cartonscollection.doc('Carton8').set({
        'modulesIntermediaires': modulesIntermediaires,
      });
      await cartonscollection.doc('Carton9').set({
        'moduleslaterauxback': moduleslaterauxback,
      });
      await cartonscollection.doc('Carton10').set({
        'moduleslaterauxfront': moduleslaterauxfront,
      });
      await cartonscollection.doc('Carton11').set({
        'calesbois': calesbois,
      });
    } else {
      switch (carton) {
        case 'Carton1':
          return await cartonscollection.doc('Carton1').set({
            'modulesVerinsLateraux': modulesVerinsLateraux,
            'cableinterverins': cableinterverins,
          });
          break;

        case 'Carton2':
        case 'Carton3':
        case 'Carton4':
          return await cartonscollection.doc(carton).set({
            'modulesVerinsLateraux': modulesVerinsLateraux,
          });
          break;
        case 'Carton5':
        case 'Carton6':
          return await cartonscollection.doc(carton).set({
            'modulesVerinsangles': modulesVerinsangles,
          });
          break;
        case 'Carton7':
        case 'Carton8':
          return await cartonscollection.doc(carton).set({
            'modulesIntermediaires': modulesIntermediaires,
          });
          break;
        case 'Carton9':
          return await cartonscollection.doc('Carton9').set({
            'moduleslaterauxback': moduleslaterauxback,
          });
          break;
        case 'Carton10':
          return await cartonscollection.doc('Carton10').set({
            'moduleslaterauxfront': moduleslaterauxfront,
          });
          break;
        case 'Carton11':
          return await cartonscollection.doc('Carton11').set({
            'calesbois': calesbois,
          });
          break;
      }
    }
  }

  Future<void> saveCheckListCartons12(
      int uid,
      bool _12boulonsM1425mm,
      bool _12ecrousM14,
      bool _1cletube22,
      bool _1cleplate22,
      bool _16boulonsM1030mm,
      bool _16ecrousM10,
      bool _1cletube17,
      bool _1cleplate17,
      bool _112boulonsM1060mm,
      bool _122ecrousM14,
      bool _18boulonsM1030mm,
      bool _18rondellesM1430mm,
      bool _18plaquettesacier,
      bool _8bogeys,
      bool _16visM416mm,
      bool _1tourneviscrusiforme,
      bool _4visM8,
      bool _1cleallen5mm,
      bool _1niveaulaser,
      bool _1cleplate14_15,
      bool _4carrenoirs,
      bool _7marqueballe,
      bool _metre,
      bool _sparebag,
      bool _50clamps,
      bool _2pairesdegants,
      bool _rangementtelec,
      bool _cablealimetationadapte,
      bool complete) async {
    final CollectionReference<Map<String, dynamic>> cartonscollection =
        FirebaseFirestore.instance
            .collection("checkLists")
            .doc(uid.toString())
            .collection('Checklist' + uid.toString());

    return await cartonscollection.doc('Carton12').set({
      '12boulonsM1425mm': _12boulonsM1425mm,
      '12ecrousM14': _12ecrousM14,
      '1cletube22': _1cletube22,
      '1cleplate22': _1cleplate22,
      '16boulonsM1030mm': _16boulonsM1030mm,
      '16ecrousM10': _16ecrousM10,
      '1cletube17': _1cletube17,
      '1cleplate17': _1cleplate17,
      '112boulonsM1060mm': _112boulonsM1060mm,
      '122ecrousM14': _122ecrousM14,
      '18boulonsM1030mm': _18boulonsM1030mm,
      '18rondellesM1430mm': _18rondellesM1430mm,
      '18plaquettesacier': _18plaquettesacier,
      '8bogeys': _8bogeys,
      '16visM416mm': _16visM416mm,
      '1tourneviscrusiforme': _1tourneviscrusiforme,
      '4visM8': _4visM8,
      '1cleallen5mm': _1cleallen5mm,
      '1niveaulaser': _1niveaulaser,
      '1cleplate14_15': _1cleplate14_15,
      '4carrenoirs': _4carrenoirs,
      '7marqueballe': _7marqueballe,
      'metre': _metre,
      'sparebag': _sparebag,
      '50clamps': _50clamps,
      '2pairesdegants': _2pairesdegants,
      'rangementtelec': _rangementtelec,
      'cablealimetationadapte': _cablealimetationadapte,
      'complete': complete
    });
  }

  AppCheckListsData _checkListFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppCheckListsData(
        id: snapshot.data()['id'],
        palette: snapshot.data()['palette'],
        caisse: snapshot.data()['caisse'],
        taillebt: snapshot.data()['taillebt'],
        planchers: snapshot.data()['planchers'],
        tapisWP: snapshot.data()['tapisWP'],
        check1: snapshot.data()['check1'],
        check2: snapshot.data()['check2'],
        check1user: snapshot.data()['check1user'],
        check2user: snapshot.data()['check2user']);
  }

  AppCheckLists _checkListFromfire(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppCheckLists(
      uid: snapshot.data()['uid'],
    );
  }

  Stream<AppCheckListsData> get checkList {
    return checkListCollection.doc(uid).snapshots().map(_checkListFromSnapshot);
  }

  Stream<AppCheckLists> get checkListuid {
    return checkListCollection.doc(uid).snapshots().map(_checkListFromfire);
  }

  List<AppCheckListsData> _checkListListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _checkListFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppCheckListsData>> get checkLists {
    return checkListCollection
        .orderBy("id", descending: true)
        .snapshots()
        .map(_checkListListFromSnapshot);
  }
}