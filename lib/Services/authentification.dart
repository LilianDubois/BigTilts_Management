import 'package:bigtitlss_management/Services/database.dart';
import 'package:bigtitlss_management/Services/notification_service.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthtificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFireBaseUser(User user) {
    initUser(user);
    return user != null ? AppUser(uid: user.uid) : null;
  }

  void initUser(User user) async {
    if (user == null) return;
    NotificationService.getToken().then((value) {
      DatabaseService(uid: user.uid).saveToken(value);
      print(value);
    });
  }

  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFireBaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFireBaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerInWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      await DatabaseService(uid: user.uid).saveUser(name, 0);

      return _userFromFireBaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
}
