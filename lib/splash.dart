import 'dart:async';
import 'package:flutter/material.dart';
import 'package:usmanya/firs_tlogin.dart';
import 'package:usmanya/home.dart';

class SecondSplashScreen extends StatefulWidget {
  const SecondSplashScreen({super.key});

  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF00796B)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('images/aqsda.jpeg'),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'جامعہ عثمانیہ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  ' دینی و فنی تعلیم کا حسین امتزاج ',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.amberAccent,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                const LinearProgressIndicator(
                  backgroundColor: Color(0xFF80CBC4),
                  color: Colors.amberAccent,
                  minHeight: 5,
                ),

                const SizedBox(height: 20),

                const Text(
                  'براہ کرم انتظار فرمائیں...\nایپ لوڈ ہو رہی ہے!',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
