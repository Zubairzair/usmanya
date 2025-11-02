import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _launchWhatsApp(BuildContext context) async {
    final phone = '923281293271';
    final message = Uri.encodeComponent("السلام علیکم، مجھے ایک ایپ بنوانی ہے۔ براہِ کرم رہنمائی فرمائیں۔");
    final whatsappUrl = Uri.parse("https://wa.me/$phone?text=$message");

    try {
      final launched = await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        final fallback = await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
        if (!fallback) {
          throw Exception('WhatsApp launch failed');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('واٹس ایپ نہ کھل سکا، براہ کرم ایپ چیک کریں')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'ڈویلپر سے رابطہ کریں',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Color(0xFF7E57C2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/zair1.jpg'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'محمد زبیر زائر',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'موبائل ایپ ڈویلپر\nFlutter | Firebase | UI/UX',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
                  const SizedBox(height: 18),
                  contactRow(Icons.email, 'hafizzubair279@gmail.com'),
                  const SizedBox(height: 10),
                  contactRow(Icons.phone, '  1293271  328 92+'),
                  const SizedBox(height: 10),
                  contactRow(Icons.location_on, 'گگومنڈی، پنجاب، پاکستان'),
                  const SizedBox(height: 30),
                  const Text(
                    'کیا آپ اپنی ایپ بنوانا چاہتے ہیں؟ ابھی رابطہ کریں',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    label: const Text(
                      "واٹس ایپ پر رابطہ کریں",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget contactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}
