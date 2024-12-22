import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/router_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:sprintinio/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sprintinio/styles/colors.dart';

// Function to setup Firebase
Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final logger = Logger();
  // use firestore locally for testing purposes
  // run the following command in the terminal to start the firestore emulator:
  // firebase emulators:start
  // const bool kDebugMode = !kReleaseMode && !kProfileMode;
  // const bool kDebugMode = true;

  if (kDebugMode) {
    logger.d('Running in debug mode');
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
    await FirebaseAuth.instance
        .useAuthEmulator('localhost', 9099, automaticHostMapping: false);
  } else {
    logger.d('Running in release mode');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await setupFirebase();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sprintinio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purplePressed),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
        ),
        useMaterial3: true,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
