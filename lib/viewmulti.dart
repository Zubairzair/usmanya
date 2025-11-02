import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMultimediaScreen extends StatelessWidget {
  final String role;

  const ViewMultimediaScreen({super.key, required this.role});

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final Uri? uri = Uri.tryParse(url);

      if (uri == null || !uri.isAbsolute) {
        throw Exception('غلط یا نامکمل لنک');
      }

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        final bool canLaunchLegacy = await canLaunchUrl(uri);
        if (canLaunchLegacy) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } else {
          throw Exception('لنک کھولنے میں ناکامی');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لنک نہیں کھولا جا سکا: ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> _deleteLink(
      BuildContext context, String docId, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تصدیق کریں"),
        content: Text("کیا آپ واقعی '$title' کو حذف کرنا چاہتے ہیں؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("نہیں")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("جی ہاں")),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('multimedia_links')
            .doc(docId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لنک حذف ہو گیا")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حذف کرنے میں ناکامی: ${e.toString()}")),
        );
      }
    }
  }

  Widget _buildButton(BuildContext context,
      {required String title, required String url, required String docId}) {
    final Uri? uri = Uri.tryParse(url);

    if (uri == null || !uri.isAbsolute) {
      return const SizedBox(); // invalid link, skip
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(context, url),
            icon: const Icon(Icons.link),
            label: Text(title, style: const TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (role == "admin" || role == "super_admin")
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteLink(context, docId, title),
            tooltip: 'حذف کریں',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لنک لسٹنگ'),
        backgroundColor: Colors.deepPurple, // 🎨 کلر اپڈیٹ
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('multimedia_links')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("کوئی لنک موجود نہیں"));
            }

            final links = snapshot.data!.docs;

            return ListView.separated(
              itemCount: links.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final data = links[index].data() as Map<String, dynamic>;
                final String title = data['title'] ?? 'نامعلوم';
                final String url = data['link'] ?? '';
                final String docId = links[index].id;

                return _buildButton(
                  context,
                  title: title,
                  url: url,
                  docId: docId,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
