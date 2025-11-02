import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffViewScreen extends StatelessWidget {
  final String role; // superadmin یا user وغیرہ

  const StaffViewScreen({Key? key, required this.role}) : super(key: key);

  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لنک نہیں کھل سکا")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خرابی: $e")),
      );
    }
  }

  Future<void> _deleteStaff(BuildContext context, String docId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تصدیق"),
        content: const Text("کیا آپ واقعی یہ ریکارڈ ڈیلیٹ کرنا چاہتے ہیں؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("نہیں"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("جی ہاں"),
          ),
        ],
      ),
    );

    if (confirm) {
      await FirebaseFirestore.instance.collection('staff').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ریکارڈ کامیابی سے ڈیلیٹ ہو گیا")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سٹاف لسٹ", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('staff')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("خرابی: ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("کوئی ریکارڈ نہیں ملا"));
          }

          return Column(
            children: [
              Container(
                color: Colors.deepPurple.shade100,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  "کل سٹاف کی تعداد: ${docs.length}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final docId = docs[index].id;

                    final link1 = (data['socialLink1'] ?? '').toString().trim();
                    final link2 = (data['socialLink2'] ?? '').toString().trim();

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.deepPurple.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.deepPurple,
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "نام: ${data['name'] ?? ''}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text("ولدیت: ${data['fatherName'] ?? ''}"),
                            Text("تعلیم: ${data['education'] ?? ''}"),
                            Text("تجربہ: ${data['experience'] ?? ''}"),
                            Text("مہارت: ${data['skills'] ?? ''}"),
                            Text("ایڈریس: ${data['address'] ?? ''}"),
                            Text("شناختی کارڈ نمبر: ${data['cnic'] ?? ''}"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (link1.isNotEmpty)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => _launchURL(context, link1),
                                    child: const Text("سوشل لنک 1"),
                                  ),
                                if (link1.isNotEmpty && link2.isNotEmpty)
                                  const SizedBox(width: 10),
                                if (link2.isNotEmpty)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => _launchURL(context, link2),
                                    child: const Text("سوشل لنک 2"),
                                  ),
                                const Spacer(),
                                if (role == "super_admin")
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteStaff(context, docId),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
