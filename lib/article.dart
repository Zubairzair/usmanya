import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final TextEditingController _articleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  Future<void> _saveArticle() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await FirebaseFirestore.instance.collection('Article').add({
          'announcement': _articleController.text.trim(), // Field name as is
          'timestamp': FieldValue.serverTimestamp(),
        });

        _articleController.clear();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("✅ کامیابی"),
            content: const Text("مضمون کامیابی سے شامل کر دیا گیا ہے۔"),
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
        title: const Text('نیا مضمون شامل کریں', style: TextStyle(color: Colors.white)),
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
                "📝 نیچے اپنا مضمون تحریر کریں:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _articleController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'یہاں اپنا مضمون لکھیں...',
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'براہِ کرم مضمون لکھیں' : null,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveArticle,
                  icon: const Icon(Icons.edit_note, color: Colors.white),
                  label: Text(
                    _isSaving ? 'محفوظ کیا جا رہا ہے...' : 'مضمون شامل کریں',
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
