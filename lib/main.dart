// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robotrafficlight/screens/local_screen.dart';
import 'package:robotrafficlight/screens/traffic_light_screen.dart';
import 'package:robotrafficlight/shared/menu_bottom.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Wakelock.enable(); // 화면 꺼짐 방지
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // 전체화면
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        canvasColor: Colors.deepPurple.shade50,
      ),
      routes: {
        '/WebServerMod': (context) =>
            const TrafficLightScreen(title: 'Flutter Demo Home Page'),
        '/LocalMod': (context) => const LocalScreen(title: 'LocaScreen')
      },
      initialRoute: '/WebServerMod',
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
