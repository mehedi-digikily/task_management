import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService{
  Future<void> init()async{

    await FirebaseMessaging.instance.requestPermission();

    onTokenRefresh();
    // foreground state
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      // Send local notification
      // then handle the notification
      _handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(((RemoteMessage message){

      // background state
      _handleNotification(message);
    }));

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);

    }

  void _handleNotification(RemoteMessage message) async{
    String messageNotification = '''
      'Tittle': ${message.notification?.title}
      'Body': ${message.notification?.body}
      'Data': ${message.data}
      ''';
    print(messageNotification);
  }

  Future<String?> getFcmToken() async {
    // Have to send to the DB via login api
    return await FirebaseMessaging.instance.getToken();
  }

  void onTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Send to db via API
    });
  }
}


  Future<void> _handleBackgroundNotification(RemoteMessage message)async {
    await Firebase.initializeApp();

    // have to call an API/save to local db
  }

