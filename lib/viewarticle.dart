import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewArticlesScreen extends StatelessWidget {
  final String role;

  const ViewArticlesScreen({super.key, required this.role});

  bool get isAdmin => role == 'admin' || role == 'super_admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مضامین', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Article') // 🔁 Changed collection name
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'کوئی مضمون دستیاب نہیں۔',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final articles = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final doc = articles[index];
              final data = doc.data() as Map<String, dynamic>;
              final message = data['announcement'] ?? ''; // field name remains same

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'آج کا مضمون',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  /// Delete icon (صرف ایڈمن کے لیے)
                  if (isAdmin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, doc.id),
                      ),
                    ),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 5,
                    color: Colors.deepPurple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        message,
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تصدیق کریں', style: TextStyle(color: Colors.red)),
        content: const Text('کیا آپ واقعی اس مضمون کو حذف کرنا چاہتے ہیں؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('نہیں'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await FirebaseFirestore.instance
                  .collection('Article')
                  .doc(docId)
                  .delete();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('مضمون کامیابی سے حذف ہو گیا۔'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('حذف کریں', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
