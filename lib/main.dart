
import 'package:budget_tracker/Widgets/auth_gate.dart';
import 'package:budget_tracker/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async { 
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

 FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true); // Ensures that database works offline
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Budget Tracker',
      builder: (context , child){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
           child: child!);
      },
      theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
  );
  }
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async{
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }
}

