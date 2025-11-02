import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final TextEditingController _announcementController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  Future<void> _saveAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await FirebaseFirestore.instance.collection('announcements').add({
          'announcement': _announcementController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        _announcementController.clear();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("✅ کامیابی"),
            content: const Text("اعلان کامیابی سے شامل کر دیا گیا ہے۔"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ٹھیک ہے"),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خرابی: $e")),
        );
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('نیا اعلان شامل کریں', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "📝 نیچے اپنا اعلان تحریر کریں:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _announcementController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'یہاں اپنا اعلان لکھیں...',
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'براہِ کرم کوئی اعلان لکھیں' : null,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveAnnouncement,
                  icon: const Icon(Icons.campaign, color: Colors.white),
                  label: Text(
                    _isSaving ? 'شامل کیا جا رہا ہے...' : 'اعلان شامل کریں',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
