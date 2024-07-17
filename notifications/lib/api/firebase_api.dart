import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications/main.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class FirebaseApi {
  // Create an instance of Firebase Messaging
  final _fireBaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request permission from user (wil prompt user)
    NotificationSettings settings = await _fireBaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logger.i('User granted permission: ${settings.authorizationStatus}');

    // Fetch the FCM token for this device
    final fCMToken = await _fireBaseMessaging.getToken();

    // Print the token (normally you would send this to your server)
    logger.i('Token: $fCMToken');

    // Initialize further settings for push notifications
    initPushNotifications();
  }

  // Function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // If the message is null, do nothing
    if (message == null) return;

    // Navigate to new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  // function to initialize foreground and background messages
  Future initPushNotifications() async {
    // Handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
