import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAddScreen extends StatefulWidget {
  const StaffAddScreen({Key? key}) : super(key: key);

  @override
  State<StaffAddScreen> createState() => _StaffAddScreenState();
}

class _StaffAddScreenState extends State<StaffAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final socialLink1Controller = TextEditingController();
  final socialLink2Controller = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final skillsController = TextEditingController();
  final addressController = TextEditingController();
  final cnicController = TextEditingController();

  bool isLoading = false;

  Future<void> addStaff() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('staff').add({
        'name': nameController.text.trim(),
        'fatherName': fatherNameController.text.trim(),
        'socialLink1': socialLink1Controller.text.trim(),
        'socialLink2': socialLink2Controller.text.trim(),
        'education': educationController.text.trim(),
        'experience': experienceController.text.trim(),
        'skills': skillsController.text.trim(),
        'address': addressController.text.trim(),
        'cnic': cnicController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("سٹاف کا ریکارڈ محفوظ ہو گیا")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("مسئلہ پیش آیا: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سٹاف کا ریکارڈ شامل کریں", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(nameController, "نام"),
              buildTextField(fatherNameController, "ولدیت"),
              buildTextField(socialLink1Controller, "سوشل لنک 1", isRequired: false),
              buildTextField(socialLink2Controller, "سوشل لنک 2", isRequired: false),
              buildTextField(educationController, "تعلیم"),
              buildTextField(experienceController, "تجربہ"),
              buildTextField(skillsController, "مہارت"),
              buildTextField(addressController, "ایڈریس"),
              buildTextField(cnicController, "شناختی کارڈ نمبر"),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isLoading ? null : addStaff,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("محفوظ کریں", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.deepPurple.shade50,
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return "براہ کرم $label درج کریں";
          }
          return null;
        },
      ),
    );
  }
}
