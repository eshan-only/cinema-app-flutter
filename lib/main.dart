import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';  // Ensure this is imported correctly
import 'package:get/get.dart';  // Import GetX (if you're using it)

Future <void> main() async {
  // Ensure Flutter bindings are initialized before running the app
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Initialize Firebase asynchronously
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );
  
  // Run the app
  runApp(App());
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cinema App',  // Provide a title if necessary
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const Home_Page(),  // Ensure Home_Page is being used here
//     );
//   }
// }
