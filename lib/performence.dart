import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddPerformanceScreen extends StatefulWidget {
  final String studentId;

  const AddPerformanceScreen({super.key, required this.studentId});

  @override
  State<AddPerformanceScreen> createState() => _AddPerformanceScreenState();
}

class _AddPerformanceScreenState extends State<AddPerformanceScreen> {
  final _formKey = GlobalKey<FormState>();

  final absentsController = TextEditingController();
  final schoolStatusController = TextEditingController();
  final complaintsController = TextEditingController();
  final quranStatusController = TextEditingController();
  final overallPerformanceController = TextEditingController();

  bool loading = false;
  String selectedMonth = DateFormat.MMMM('ur_PK').format(DateTime.now());
  int selectedYear = DateTime.now().year;

  Future<void> savePerformance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      await FirebaseFirestore.instance.collection('performance').add({
        'studentId': widget.studentId.trim(),
        'month': selectedMonth,
        'year': selectedYear,
        'absents': int.tryParse(absentsController.text) ?? 0,
        'schoolStatus': schoolStatusController.text.trim(),
        'complaints': complaintsController.text.trim(),
        'quranStatus': quranStatusController.text.trim(),
        'overallPerformance': overallPerformanceController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کارکردگی محفوظ ہو گئی')),
      );

      absentsController.clear();
      schoolStatusController.clear();
      complaintsController.clear();
      quranStatusController.clear();
      overallPerformanceController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خرابی: ${e.toString()}')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> deletePerformance(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تصدیق کریں'),
        content: const Text('کیا آپ واقعی اس کارکردگی کو حذف کرنا چاہتے ہیں؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('نہیں')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('جی ہاں')),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('performance').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('کارکردگی حذف کر دی گئی')),
    );
  }

  InputDecoration fieldStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  // Widget buildPreviousPerformances() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection('performance')
  //         .where('studentId', isEqualTo: widget.studentId.trim())
  //         .orderBy('createdAt', descending: true)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Padding(
  //           padding: EdgeInsets.all(20),
  //           child: Center(child: CircularProgressIndicator()),
  //         );
  //       }
  //
  //       if (snapshot.hasError) {
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 10),
  //           child: Text('خرابی: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
  //         );
  //       }
  //
  //       final docs = snapshot.data?.docs ?? [];
  //
  //       if (docs.isEmpty) {
  //         return const Padding(
  //           padding: EdgeInsets.only(top: 10),
  //           child: Text('کوئی سابقہ کارکردگی نہیں ملی'),
  //         );
  //       }
  //
  //       return ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: docs.length,
  //         itemBuilder: (context, index) {
  //           final performance = docs[index];
  //           final data = performance.data() as Map<String, dynamic>;
  //
  //           return Card(
  //             color: Colors.grey.shade100,
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //             child: ListTile(
  //               title: Text("${data['month']} ${data['year']}"),
  //               subtitle: Text("کارکردگی: ${data['overallPerformance'] ?? 'نہیں'}"),
  //               trailing: IconButton(
  //                 icon: const Icon(Icons.delete, color: Colors.red),
  //                 onPressed: () => deletePerformance(performance.id),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  Widget buildPreviousPerformances() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('performance')
          .where('studentId', isEqualTo: widget.studentId.trim())
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('خرابی: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('کوئی سابقہ کارکردگی نہیں ملی'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final performance = docs[index];
            final data = performance.data() as Map<String, dynamic>;

            return Card(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                isThreeLine: true,
                title: Text("${data['month']} ${data['year']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("چھٹیاں: ${data['absents'] ?? '0'}"),
                    Text("سکول کیفیت: ${data['schoolStatus'] ?? 'نہیں'}"),
                    Text("شکایات: ${data['complaints'] ?? 'کوئی نہیں'}"),
                    Text("قرآن شعبہ: ${data['quranStatus'] ?? 'نہیں'}"),
                    Text("مجموعی کارکردگی: ${data['overallPerformance'] ?? 'نہیں'}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deletePerformance(performance.id),
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('ماہانہ کارکردگی', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedMonth,
                  decoration: fieldStyle("مہینہ منتخب کریں"),
                  items: List.generate(12, (index) {
                    final monthName = DateFormat.MMMM('ur_PK').format(DateTime(0, index + 1));
                    return DropdownMenuItem<String>(
                      value: monthName,
                      child: Text(monthName),
                    );
                  }),
                  onChanged: (value) => setState(() => selectedMonth = value ?? selectedMonth),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: absentsController,
                  keyboardType: TextInputType.number,
                  decoration: fieldStyle("اس ماہ چھٹیاں"),
                  validator: (value) => value == null || value.trim().isEmpty ? 'درج کریں' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: schoolStatusController,
                  decoration: fieldStyle("شعبہ سکول: کیفیت"),
                  validator: (value) => value == null || value.trim().isEmpty ? 'درج کریں' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: complaintsController,
                  decoration: fieldStyle("شکایات (اگر کوئی)"),
                  validator: (value) => value == null || value.trim().isEmpty ? 'درج کریں' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: quranStatusController,
                  decoration: fieldStyle("شعبہ حفظ قرآن: کتنا پڑھا؟"),
                  validator: (value) => value == null || value.trim().isEmpty ? 'درج کریں' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: overallPerformanceController,
                  decoration: fieldStyle("اس ماہ کی مجموعی کارکردگی"),
                  validator: (value) => value == null || value.trim().isEmpty ? 'درج کریں' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: loading ? null : savePerformance,
                  icon: const Icon(Icons.save),
                  label: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("کارکردگی محفوظ کریں"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 25),
                const Text("سابقہ کارکردگی:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                buildPreviousPerformances(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
