import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static void initialize() {
    // for ios and web
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((event) {
      print('A new onMessage event was published!');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  static Future<String> getToken() async {
    return FirebaseMessaging.instance.getToken(
        vapidKey:
            "BGGJH_W6_Rx1SoJ7KqSk86bUqb5E-BJDyXX8vb_AzCuO0_okdST8z67KKL4vTcJ3K2k8vIJ0vv7Xb7jCLL3-Dw0");
  }
}
