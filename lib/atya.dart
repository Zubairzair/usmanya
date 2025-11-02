import 'package:flutter/material.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اپنی آخرت سنواریں', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Image
              Container(
                width: double.infinity,
                child: Image.asset(
                  'images/Usmanya2.jpg', // make sure this image is in your assets folder and listed in pubspec.yaml
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Text Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'جامعہ عثمانیہ، ضلع خوشاب میں 100 طلبہ و طالبات، 8 اساتذہ کرام، معلمات اور عملہ کی نگرانی میں قرآن و سنت کی تعلیمات اور فنی تعلیم سے فیض یاب ہو رہے ہیں۔حدیث مبارکہ میں ہے کہ: ',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "جب انسان مر جاتا ہے تو اس کے اعمال منقطع ہو جاتے ہیں، سوائے تین چیزوں کے: صدقہ جاریہ، ایسا علم جس سے فائدہ اُٹھایا جائے، یا نیک اولاد جو اس کے لیے دعا کرے",style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Divider(thickness: 1.5),
                    const SizedBox(height: 10),
                    Text(
                      'بینک و ایزی پیسہ تفصیلات برائے جامعہ عثمانیہ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '💳 Allied Bank\nAccount Title: Malik Ahmad Sher\nAccount No: 0010136352060017',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '📱 Easypaisa\nAccount No: 03458184355\nAccount Title: اویس المصطفیٰ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
