import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase
import 'firebase_options.dart';

// Controllers
import 'controller/itinerary_controller.dart';

// Views
import 'view/login_page.dart';
import 'view/home_page.dart';
import 'view/itinerary_form_page.dart';
import 'view/about_us_page.dart';
import 'view/contact_us_page.dart';
import 'view/profile_page.dart';
import 'view/settings_page.dart';
import 'view/chat_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Launch app
    runApp(const TravelApp());
  } catch (e, stackTrace) {
    debugPrint("❌ App startup error: $e");
    debugPrint("$stackTrace");
  }
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItineraryController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Itinerary Voyager',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 4,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/generator': (context) => const ItineraryFormPage(), // 🔧 Fixed constructor
          '/about': (context) => const AboutUsPage(),
          '/contact': (context) => const ContactUsPage(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/chat': (context) => const ChatPage(),
        },
      ),
    );
  }
}
