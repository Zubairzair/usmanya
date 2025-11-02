import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('رازداری کی پالیسی', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'رازداری کی پالیسی',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'جامعہ عثمانیہ، وادی سون، سوڈھی جیوالی، ضلع خوشاب، اپنے طلباء، والدین اور اساتذہ کی معلومات کی رازداری کو بہت اہمیت دیتا ہے۔ یہ ایپلیکیشن تعلیمی اور انتظامی امور کو منظم کرنے کے لیے تیار کی گئی ہے، اور تمام ڈیٹا کی حفاظت کو یقینی بنایا گیا ہے۔',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 12),
              Text(
                '۱۔ ڈیٹا جمع کرنا:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'ہم صرف ضروری معلومات جمع کرتے ہیں جیسے کہ طالب علم کا نام، سرپرست کا نام، جماعت، رابطہ نمبر، اور فیس کی تفصیلات۔ یہ معلومات صرف ریکارڈ رکھنے کے لیے استعمال ہوتی ہیں اور کسی تیسرے فریق کو فراہم نہیں کی جاتیں۔',
              ),
              SizedBox(height: 12),
              Text(
                '۲۔ ڈیٹا کا استعمال:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'یہ تمام معلومات صرف جامعہ عثمانیہ کے اندرونی انتظامی امور جیسے فیس، کتب، طالب علم کی کارکردگی، اور ریکارڈ کی ترتیب کے لیے استعمال ہوتی ہیں۔',
              ),
              SizedBox(height: 12),
              Text(
                '۳۔ ڈیٹا کی سیکیورٹی:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'تمام معلومات ایک محفوظ کلاؤڈ ڈیٹابیس (Firebase) میں محفوظ کی جاتی ہیں جو مخصوص لاگ اِن اور سیکیورٹی پالیسیز کے ذریعے محفوظ ہے۔ صرف ایڈمن کو رسائی حاصل ہے۔ کوئی غیر متعلقہ فرد ریکارڈز تک رسائی حاصل نہیں کر سکتا۔',
              ),
              SizedBox(height: 12),
              Text(
                '۴۔ تھرڈ پارٹی سروسز:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'یہ ایپلیکیشن کسی بھی قسم کی تھرڈ پارٹی ایڈورٹائزمنٹ یا ایسی سروسز کا استعمال نہیں کرتی جو آپ کی ذاتی معلومات تک رسائی رکھتی ہوں۔',
              ),
              SizedBox(height: 12),
              Text(
                '۵۔ ذمہ داری:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'جامعہ عثمانیہ کو یہ اختیار حاصل ہے کہ وہ وقتاً فوقتاً اپنی تعلیمی یا قانونی ضروریات کے مطابق اس پالیسی کو تبدیل یا اپڈیٹ کر سکتا ہے۔',
              ),
              SizedBox(height: 12),
              Text(
                '۶۔ منظوری:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'اس ایپلیکیشن کے استعمال کا مطلب ہے کہ آپ اس پالیسی سے متفق ہیں۔ ایپ کا مسلسل استعمال ہماری شرائط سے آپ کی رضامندی کو ظاہر کرتا ہے۔',
              ),
              SizedBox(height: 20),
              Text(
                'اگر آپ کو اس پالیسی کے حوالے سے کوئی خدشہ یا سوال ہو، تو آپ ہم سے براہ راست رابطہ کر سکتے ہیں: جامعہ عثمانیہ، وادی سون، ضلع خوشاب۔',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
