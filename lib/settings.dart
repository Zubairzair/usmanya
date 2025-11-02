import 'package:flutter/material.dart';
import 'package:usmanya/about.dart';
import 'package:usmanya/faq.dart';
import 'package:usmanya/privacy_policy.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = 'اردو';

  final List<String> languages = [
    'اردو', 'پنجابی', 'سرائیکی', 'انگریزی', 'عربی', 'فارسی', 'پشتو', 'ہندی',
    'فرانسیسی', 'جرمن', 'ترکی', 'چینی', 'جاپانی', 'کوریائی', 'روسی', 'سپینش',
    'اطالوی', 'ڈچ', 'تھائی', 'ویتنامی', 'بنگالی', 'تمل', 'تیلگو', 'سندھی',
    'پولش', 'رومانی', 'مالائی', 'انڈونیشی', 'سویڈش', 'نارویجن', 'سلوواک', 'فنش',
    'یونانی', 'عبرانی', 'چیک', 'ڈینش', 'ہنگرین', 'گجراتی', 'ماراتھی', 'پرتگالی'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ترتیبات', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ایپ کی ترتیبات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6, color: Colors.deepPurple),
            title: const Text('ڈارک موڈ'),
            subtitle: const Text('روشن اور سیاہ تھیم کے درمیان تبدیلی کریں'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.deepPurple),
            title: const Text('زبان'),
            subtitle: Text('منتخب شدہ: $selectedLanguage'),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.deepPurple),
            title: const Text('مدد اور عمومی سوالات'),
            subtitle: const Text('عام سوالات کے جوابات دیکھیں'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FAQScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.deepPurple),
            title: const Text('ادارے کے بارے میں'),
            subtitle: const Text('جامعہ عثمانیہ کا تعارف'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutSchoolScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Colors.deepPurple),
            title: const Text('رازداری کی پالیسی'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
