import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase_app/navigation/route_generator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/selected_location_provider.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            authDomain: dotenv.env['authDomain'],
            storageBucket: dotenv.env['storageBucket'],
            measurementId: dotenv.env['measurementId'],
            apiKey: dotenv.env['apiKey']!,
            appId: dotenv.env['appId']!,
            messagingSenderId: dotenv.env['messagingSenderId']!,
            projectId: dotenv.env['projectId']!));
  } else {
    await Firebase.initializeApp();
  }

  runApp(ChangeNotifierProvider(
      create: (context) => SelectedLocationProvider(), child: const Parky()));
}

class Parky extends StatelessWidget {
  const Parky({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme:
              GoogleFonts.ibmPlexSansTextTheme(Theme.of(context).textTheme)),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
