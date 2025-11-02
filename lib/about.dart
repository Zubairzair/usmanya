import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSchoolScreen extends StatelessWidget {
  const AboutSchoolScreen({super.key});

  void _openWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/923458184355');
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        final fallback = await launchUrl(url, mode: LaunchMode.platformDefault);
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جامعہ عثمانیہ', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'جامعہ عثمانیہ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'ایک ایسا ادارہ جہاں علم، اخلاق اور تربیت کا حسین امتزاج ہے',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'ہم تعلیم دیتے ہیں، تجارت نہیں کرتے',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(height: 30, thickness: 1.5),

                const Text(
                  '📖 ادارے کا تعارف',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                const Text(
                  'جامعہ عثمانیہ، وادی سون، سوڈھی جیوالی، ضلع خوشاب میں قائم ایک منفرد دینی و عصری تعلیمی ادارہ ہے جہاں قرآن کریم کا ناظرہ، حفظ، تجوید کے ساتھ ساتھ کمپیوٹر کورسز اور فنی تعلیم کا بھی اہتمام کیا جاتا ہے۔ یہاں طلبہ کی شخصیت سازی، اخلاقی تربیت، اور عصری علوم کے امتزاج پر بھرپور توجہ دی جاتی ہے۔',
                  style: TextStyle(fontSize: 15, height: 1.5),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                const Text(
                  'ادارے میں حفظ قرآن کا ایسا مربوط اور منظم نظام رائج ہے جو عام مدارس میں کم ہی دیکھنے کو ملتا ہے۔ طلباء کی انفرادی نگرانی، ماہانہ جائزہ، اور مخصوص اہداف کی بنیاد پر تعلیمی نظام ترتیب دیا گیا ہے تاکہ ہر طالب علم نہ صرف حافظِ قرآن بلکہ ایک باکردار مسلمان بھی بنے۔',
                  style: TextStyle(height: 1.5),
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 20),
                const Text(
                  '🌟 اہم خصوصیات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text('- ناظرہ، حفظ، اور تجوید کی جدید انداز میں تعلیم'),
                const Text('- کمپیوٹر کورسز اور ہنر سکھانے کے پروگرام'),
                const Text('- تربیتی نشستیں، اخلاقی لیکچرز، اور تعلیمی جائزے'),
                const Text('- دینداری، نظم و ضبط اور خدمتِ دین کی تربیت'),

                const SizedBox(height: 20),
                const Text(
                  '📍 رابطہ معلومات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text('📞 فون نمبر:8184355  345 ۤۤۤ92+'),
                const Text('📍 مقام: وادی سون، سوڈھی جیوالی، ضلع خوشاب، پاکستان'),

                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'ہم قوم کے بچوں کو سنوارنے کے مشن پر ہیں',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _openWhatsApp(context),
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
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
