import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/alt_screens/IntroScreen.dart';
import 'package:better_assignments/main_tabs/star.dart';
import 'package:better_assignments/main_tabs/home.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:better_assignments/models/subject.dart';
import 'package:better_assignments/main_tabs/tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Set path for storage and initalize Hive directory
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();

  // Set orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Hive :D
  Hive.init(appDir.path);

  // Register all necessary adapters (Subject & Assignment Adapter)
  Hive.registerAdapter(
    AssignModelAdapter(),
  );
  Hive.registerAdapter(
    SubjectAdapter(),
  );

  // Open new box, subjBox for subjects, assignBox for assignments
  await Hive.openBox("subjBox");
  await Hive.openBox("assignBox");
  await Hive.openBox("prefs");

  // FOR NOTIFICATIONS
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelKey: 'short',
        channelName: 'short warning',
        channelDescription: 'Default 12 hours before due.',
        enableVibration: true,
        vibrationPattern: mediumVibrationPattern,
      ),
      NotificationChannel(
        channelKey: 'long',
        channelName: 'long warning',
        channelDescription: 'Default 24 hours before due',
        defaultColor: Colors.purple,
        vibrationPattern: lowVibrationPattern,
        enableVibration: true,
      ),
      // 2 days hours when prioritized
      NotificationChannel(
        channelKey: 'star',
        channelName: 'Priority notifications',
        channelDescription: 'Default 2 days before due',
        defaultColor: Colors.red,
        enableVibration: true,
        vibrationPattern: mediumVibrationPattern,
      )
    ],
  );

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = Hive.box("prefs");

  // Contains all necessary routes + theme related stuff
  @override
  Widget build(BuildContext context) {
    final _isDark = prefs.get('isDark', defaultValue: true);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AssignGo',
      defaultTransition: Transition.upToDown,
      theme: ThemeData.light().copyWith(
        // TimePicker theme
        timePickerTheme: TimePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        // Bottom Sheet theme
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ),
        // Text Themes
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
          bodyText1: TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        // Appbar theme
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          color: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
        ),
        // Card theme
        cardTheme: CardTheme(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Colors.grey[900],
        // TimePicker theme
        timePickerTheme: TimePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        // Bottom Sheet theme
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ),
        // Text Themes
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyText1: TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
        ),
        // Appbar theme
        appBarTheme: AppBarTheme(
          centerTitle: false,
          color: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
        ),
        // Card theme
        cardTheme: CardTheme(
          color: Colors.grey[850],
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      initialRoute:
          // TODO: Introduction screen, update default values later
          prefs.get("firstLaunch", defaultValue: 0) == 0 ? "/" : "/",
      // prefs.get("firstLaunch", defaultValue: 1) == 0 ? "/intro" : "/",
      routes: {
        "/": (context) => TabView(),
        "/home": (context) => Home(),
        "/intro": (context) => IntroScreen(),
        "/star": (context) => Star(),
      },
    );
  }

  void dispose() {
    Hive.close();
  }
}
