import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:usmanya/splash.dart';
import 'package:usmanya/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ur_PK', null);
  runApp(const Usmanya());
}

class Usmanya extends StatelessWidget {
  const Usmanya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('ur', 'PK'),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ur', 'PK'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'NotoNastaliqUrdu',
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: SecondSplashScreen(),
    );
  }
}
