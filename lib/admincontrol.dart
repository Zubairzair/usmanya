import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminControlPanel extends StatefulWidget {
  const AdminControlPanel({super.key});

  @override
  State<AdminControlPanel> createState() => _AdminControlPanelState();
}

class _AdminControlPanelState extends State<AdminControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ایڈمن کنٹرول پینل", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'admin')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("کوئی ایڈمن موجود نہیں", style: TextStyle(fontSize: 16)));
          }

          final admins = snapshot.data!.docs;

          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final doc = admins[index];
              final email = doc['email'] ?? '';
              final uid = doc.id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text("ایڈمن: $email"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _demoteFromAdmin(uid),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAdminDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddAdminDialog() {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("نیا ایڈمن شامل کریں"),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: "فون نمبر درج کریں (11 ہندسے)",
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("منسوخ"),
          ),
          ElevatedButton(
            onPressed: () async {
              final phone = phoneController.text.trim();
              final email = "$phone@mail.com";

              final query = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: email)
                  .get();

              if (query.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("یہ صارف موجود نہیں، پہلے رجسٹریشن کریں")),
                );
              } else {
                final docId = query.docs.first.id;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(docId)
                    .update({'role': 'admin'});

                Navigator.pop(context);
                setState(() {}); // Refresh list
              }
            },
            child: const Text("ایڈمن بنائیں"),
          ),
        ],
      ),
    );
  }

  void _demoteFromAdmin(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تصدیق کریں"),
        content: const Text("کیا آپ واقعی اس ایڈمن کو ختم کرنا چاہتے ہیں؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("نہیں"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ہاں"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'role': 'user',
      });

      setState(() {}); // UI refresh
    }
  }
}