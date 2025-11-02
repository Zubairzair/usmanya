import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMultimediaScreen extends StatefulWidget {
  const AddMultimediaScreen({super.key});

  @override
  State<AddMultimediaScreen> createState() => _AddMultimediaScreenState();
}

class _AddMultimediaScreenState extends State<AddMultimediaScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  bool loading = false;

  Future<void> addMultimediaLink() async {
    final title = titleController.text.trim();
    String link = linkController.text.trim().replaceAll(' ', '');

    if (title.isEmpty || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم دونوں فیلڈز مکمل کریں')),
      );
      return;
    }

    if (!link.startsWith('http://') && !link.startsWith('https://')) {
      link = 'https://$link';
    }

    final Uri? uri = Uri.tryParse(link);
    if (uri == null || !uri.isAbsolute) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('درست لنک درج کریں')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance.collection('multimedia_links').add({
        'title': title,
        'link': link,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کامیابی سے محفوظ ہو گیا')),
      );

      titleController.clear();
      linkController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خرابی: ${e.toString()}')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نیا مواد شامل کریں"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: inputStyle("عنوان درج کریں"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: linkController,
              decoration: inputStyle("لنک درج کریں (مثلاً یوٹیوب ویڈیو یا کوئی URL)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: loading ? null : addMultimediaLink,
              icon: const Icon(Icons.add),
              label: loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text("محفوظ کریں"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
