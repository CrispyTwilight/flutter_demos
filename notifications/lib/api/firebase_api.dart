import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:notifications/main.dart';

Logger logger = Logger();

// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  _logMessageDetails(message, 'background');
  // TODO: Add more logic here to handle the message, if needed
}

void _logMessageDetails(dynamic message, String context) {
  if (message is RemoteMessage) {
    logger.i("Handling a $context message: ${message.messageId}");
    logger.i('Message data: ${message.data}');
    logger.i('Message notification: ${message.notification?.title}');
    logger.i('Message notification: ${message.notification?.body}');
  } else if (message is RemoteNotification) {
    logger.i("Handling a $context notification");
    logger.i('Notification title: ${message.title}');
    logger.i('Notification body: ${message.body}');
  }
}

/// The FirebaseApi class is used to handle all Firebase Cloud Messaging (FCM)
class FirebaseApi {
  final _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define a notification channel for Android
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
    audioAttributesUsage: AudioAttributesUsage.notification,
  );

  // Function to initialize notifications
  Future<void> initNotifications() async {
    await _requestPermission();
    await _fetchAndLogToken();
    _initializePushNotifications();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    logger.i('Permission granted: ${settings.authorizationStatus}');
  }

  Future<void> _fetchAndLogToken() async {
    try {
      final fCMToken = await _messaging.getToken();
      // TODO: Send token to server for storage.
      logger.i('Token: $fCMToken');
      _messaging.onTokenRefresh.listen((fcmToken) {
        logger.i('Token refreshed: $fcmToken');
        // TODO: If necessary, send token to server.
      }).onError((err) {
        logger.e('Error getting refreshed token: $err');
      });
    } catch (e) {
      logger.e('Error fetching token: $e');
    }
  }

  // Function to create notification channel
  Future<void> _createNotificationChannel() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Function to set up foreground notification listener
  void _setupForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _showLocalNotification(notification);
      }
    });
  }

  void _showLocalNotification(RemoteNotification notification) {
    _logMessageDetails(notification, 'foreground');
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'sms_icon94x94',
          // other properties...
        ),
      ),
    );
  }

  // Function to initialize foreground and background messages
  Future<void> _initializePushNotifications() async {
    // Create notification channel
    await _createNotificationChannel();
    // Set up foreground notification listener
    _setupForegroundNotificationListener();
    // Define the background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // Handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // Attach event listeners for when a notification opens the app from background
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  // Function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // If the message is null, do nothing
    if (message == null) return;

    // TODO: Add more logic here to handle the message

    // Navigate to new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }
}

// This is for apple devices in the future
// Future<void> setForegroundNotificationPresentationOptions() async {
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true, // Required to display a heads up notification
//     badge: true,
//     sound: true,
//   );
// }

// This is how to make a data-only message high priority from the server
// // Set Android priority to "high"
//   android: {
//     priority: "high",
//   },
//   // Add APNS (Apple) config
//   apns: {
//     payload: {
//       aps: {
//         contentAvailable: true,
//       },
//     },
//   }
