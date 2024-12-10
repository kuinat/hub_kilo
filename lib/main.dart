import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DefaultFirebaseOptions.currentPlatform;

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}
 AndroidNotificationChannel channel;

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => GlobalService().init());
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  //await Get.putAsync(() => TranslationService().init());
  Get.log('All services started...');


  await getAuthorizationKey();
}

Future getAuthorizationKey()async{
  var headers = {
    'Cookie': 'frontend_lang=en_US; session_id=789e5ac1e4a71f11af77349fc61979cfc6e39206'
  };
  var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/last/get_authorization_key'));
  request.body = '''{\n    "jsonrpc": "2.0"\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final data = await response.stream.bytesToString();
    Domain.authorization = "Basic ${json.decode(data)['authorization_key']}";
    await getApiKey();
    print("new authorization: ${Domain.authorization}");
  }
  else {
    print(response.reasonPhrase);
  }
}

Future getApiKey()async{
  var headers = {
    'Cookie': 'frontend_lang=en_US; session_id=789e5ac1e4a71f11af77349fc61979cfc6e39206'
  };
  var request = http.Request('GET', Uri.parse('https://preprod.hubkilo.com/last/get_api_key'));
  request.body = '''{\n    "jsonrpc": "2.0"\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final data = await response.stream.bytesToString();
    Domain.apiKey = "${json.decode(data)['api_key']}";
    print("new api_key: ${Domain.apiKey}");
  }
  else {
    print(response.reasonPhrase);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}

class Domain{

  static var serverPort = "https://preprod.hubkilo.com/api/v1";
  static var serverPort2 = "https://preprod.hubkilo.com/api";
  static var apiKey = "CE46G5078WKP336YFAFIDUHFRM3EEYIM";
  static var adminFee = 0.07;
  static var deviceToken;

  static var googleUser = false;
  static var googleImage = '';
  static var authorization = "Basic ZmlraXNoLmVsQGdtYWlsLmNvbTpBemVydHkxMjM0NSU=";

  //static var authorization = "Basic ZnJpZWRyaWNoOkF6ZXJ0eTEyMzQ1JQ==";
  static var AppName = "HubColis";
  static Map<String, String> getTokenHeaders() {
    Map<String, String> headers = new Map();
    headers['Authorization'] = authorization;
    headers['accept'] = 'application/json';
    return headers;
  }


}

void main() async {
  var languageBox = await GetStorage();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initServices();

   await Hive.initFlutter();
   await Hive.openBox('myBox');
   await Hive.openBox('notifications');

  HttpOverrides.global = MyHttpOverrides();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        "high_importance_channel", 'High Importance Notifications');
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(
    GetMaterialApp(
      title: Domain.AppName,
      initialRoute: Theme1AppPages.INITIAL,
      onReady: () async {
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      getPages: Theme1AppPages.routes,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'),
        Locale('fr')// Spanish
      ],
      locale: Locale.fromSubtags(languageCode: languageBox.read('language')==null?'fr':languageBox.read('language')),
      //supportedLocales: Get.find<TranslationService>().supportedLocales(),
      //translationsKeys: Get.find<TranslationService>().translations,
      //locale: Get.find<TranslationService>().getLocale(),
      //fallbackLocale: Get.find<TranslationService>().getLocale(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  ));
}
