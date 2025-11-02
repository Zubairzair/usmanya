import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewPerformanceScreen extends StatefulWidget {
  const ViewPerformanceScreen({super.key});

  @override
  State<ViewPerformanceScreen> createState() => _ViewPerformanceScreenState();
}

class _ViewPerformanceScreenState extends State<ViewPerformanceScreen> {
  List<Map<String, dynamic>> performanceList = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPerformance();
  }

  Future<void> fetchPerformance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("یوزر لاگ ان نہیں ہے");

      final email = user.email ?? '';
      final phoneFromEmail = email.split('@').first.trim();

      if (phoneFromEmail.isEmpty || phoneFromEmail.length < 10) {
        throw Exception("فون نمبر ای میل سے حاصل نہیں ہو سکا");
      }

      final studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('phone', isEqualTo: phoneFromEmail)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        throw Exception("آپ سٹوڈنٹ نہیں ہیں، ریکارڈ موجود نہیں");
      }

      final studentId = studentSnapshot.docs.first.id;

      final performanceSnapshot = await FirebaseFirestore.instance
          .collection('performance')
          .where('studentId', isEqualTo: studentId)
          .orderBy('createdAt', descending: true)
          .get();

      final data = performanceSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        performanceList = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Widget buildPerformanceCard(Map<String, dynamic> perf) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${perf['month']} ${perf['year']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text("چھٹیاں: ${perf['absents']}"),
            Text("سکول: ${perf['schoolStatus']}"),
            Text("حفظ قرآن: ${perf['quranStatus']}"),
            Text("شکایات: ${perf['complaints']}"),
            Text("مجموعی کارکردگی: ${perf['overallPerformance']}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('میری ماہانہ کارکردگی'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              )
            : performanceList.isEmpty
            ? const Center(child: Text("کوئی کارکردگی دستیاب نہیں"))
            : ListView.builder(
                itemCount: performanceList.length,
                itemBuilder: (context, index) {
                  return buildPerformanceCard(performanceList[index]);
                },
              ),
      ),
    );
  }
}
