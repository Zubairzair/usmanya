import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usmanya/performence.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:usmanya/update.dart'; // ← یہی لائن ضروری تھی

class StudentListScreen extends StatelessWidget {
  final String userRole;
  final String searchQuery;

  const StudentListScreen({
    super.key,
    required this.userRole,
    required this.searchQuery,
  });

  Stream<QuerySnapshot> getStudentStream() {
    final collection = FirebaseFirestore.instance.collection('students');
    if (searchQuery.trim().isNotEmpty) {
      return collection
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: searchQuery + 'z')
          .snapshots();
    } else {
      return collection.snapshots();
    }
  }

  Future<void> _deleteStudent(BuildContext context, String docId, String? publicId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تصدیق کریں'),
        content: const Text('کیا آپ واقعی اس طالب علم کا ریکارڈ حذف کرنا چاہتے ہیں؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('نہیں'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('جی ہاں'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('students').doc(docId).delete();

      if (publicId != null && publicId.isNotEmpty) {
        const cloudName = 'dtc7wh17n';
        const apiKey = '369979823495223';
        const apiSecret = 'cAU6Byok-JxETFMdQk1fRBO5j1M';

        final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final signatureString = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
        final signature = sha1.convert(utf8.encode(signatureString)).toString();

        final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');
        final response = await http.post(url, body: {
          'public_id': publicId,
          'api_key': apiKey,
          'timestamp': '$timestamp',
          'signature': signature,
        });

      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ریکارڈ حذف کر دیا گیا')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('طلبہ کا ریکارڈ', style: TextStyle(color: Colors.white)),
    //     backgroundColor: Colors.deepPurple,
    //     iconTheme: const IconThemeData(color: Colors.white),
    //   ),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: getStudentStream(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //
    //       final students = snapshot.data!.docs;
    //
    //       if (students.isEmpty) {
    //         return const Center(child: Text('کوئی ریکارڈ موجود نہیں'));
    //       }
    //
    //       return ListView.builder(
    //         padding: const EdgeInsets.all(12),
    //         itemCount: students.length,
    //         itemBuilder: (context, index) {
    //           final student = students[index];
    //           final data = student.data() as Map<String, dynamic>;
    //           final imageUrl = data['imageUrl'] ?? '';
    //           final publicId = data['publicId'] ?? '';
    //
    //           return Card(
    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //             margin: const EdgeInsets.symmetric(vertical: 10),
    //             elevation: 4,
    //             color: Colors.deepPurple.shade50,
    //             child: Padding(
    //               padding: const EdgeInsets.all(12),
    //               child: Column(
    //                 children: [
    //                   CircleAvatar(
    //                     radius: 45,
    //                     backgroundColor: Colors.deepPurple.shade100,
    //                     backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
    //                     child: imageUrl.isEmpty
    //                         ? const Icon(Icons.image, size: 40, color: Colors.grey)
    //                         : null,
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     data['name'] ?? '',
    //                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //                   ),
    //                   if (userRole != 'user') ...[
    //                     const SizedBox(height: 6),
    //                     Text('ولدیت: ${data['fatherName'] ?? ''}'),
    //                     Text('فون: ${data['phone'] ?? ''}'),
    //                     Text('بے فارم نمبر: ${data['bayForm'] ?? ''}'),
    //                     Text('پتہ: ${data['address'] ?? ''}'),
    //                     Text('تاریخِ پیدائش: ${data['dob'] ?? ''}'),
    //                     Text('سابقہ تعلیم: ${data['education'] ?? ''}'),
    //                     const SizedBox(height: 10),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                       children: [
    //                         IconButton(
    //                           icon: const Icon(Icons.edit, color: Colors.blue),
    //                           onPressed: () {
    //                             Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                 builder: (context) => EditStudentScreen(
    //                                   studentId: student.id,
    //                                   studentData: data,
    //                                 ),
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                         IconButton(
    //                           icon: const Icon(Icons.delete, color: Colors.red),
    //                           onPressed: () => _deleteStudent(context, student.id, publicId),
    //                         ),
    //                         ElevatedButton.icon(
    //                           style: ElevatedButton.styleFrom(
    //                             backgroundColor: Colors.deepPurple,
    //                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                           ),
    //                           label: const Text('ماہانہ کارکردگی', style: TextStyle(color: Colors.white, fontSize: 13)),
    //                           onPressed: () {
    //                             Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                 builder: (context) => AddPerformanceScreen(
    //                                   studentId: student.id,
    //                                 ),
    //                               ),
    //                             );
    //
    //                           },
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ],
    //               ),
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
    //@override
    //Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('طلبہ کا ریکارڈ', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: getStudentStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final students = snapshot.data!.docs;

            if (students.isEmpty) {
              return const Center(child: Text('کوئی ریکارڈ موجود نہیں'));
            }

            return Column(
              children: [
                // ٹوٹل طلبہ کا ریکارڈ
                Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: Text(
                    "کل طلبہ: ${students.length}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),

                // طلبہ کی لسٹ
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final data = student.data() as Map<String, dynamic>;
                      final imageUrl = data['imageUrl'] ?? '';
                      final publicId = data['publicId'] ?? '';

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        color: Colors.deepPurple.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              // نمبر سرکل
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
                              const SizedBox(height: 10),

                              // تصویر
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.deepPurple.shade100,
                                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                                child: imageUrl.isEmpty
                                    ? const Icon(Icons.image, size: 40, color: Colors.grey)
                                    : null,
                              ),

                              const SizedBox(height: 10),
                              Text(
                                data['name'] ?? '',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),

                              if (userRole != 'user') ...[
                                const SizedBox(height: 6),
                                Text('ولدیت: ${data['fatherName'] ?? ''}'),
                                Text('فون: ${data['phone'] ?? ''}'),
                                Text('بے فارم نمبر: ${data['bayForm'] ?? ''}'),
                                Text('پتہ: ${data['address'] ?? ''}'),
                                Text('تاریخِ پیدائش: ${data['dob'] ?? ''}'),
                                Text('سابقہ تعلیم: ${data['education'] ?? ''}'),
                                const SizedBox(height: 10),

                                // بٹن
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditStudentScreen(
                                              studentId: student.id,
                                              studentData: data,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteStudent(context, student.id, publicId),
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      label: const Text(
                                        'ماہانہ کارکردگی',
                                        style: TextStyle(color: Colors.white, fontSize: 13),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddPerformanceScreen(
                                              studentId: student.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
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

