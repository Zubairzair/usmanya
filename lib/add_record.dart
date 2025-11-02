import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bayFormController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  File? selectedImage;
  bool isUploading = false;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<Map<String, dynamic>?> uploadImage(File imageFile) async {
    const cloudName = 'dtc7wh17n';
    const uploadPreset = 'usmanya';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return {
        'imageUrl': jsonData['secure_url'],
        'publicId': jsonData['public_id'],
      };
    } else {
      return null;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _saveStudentRecord() async {
    if (_formKey.currentState!.validate()) {
      if (selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('براہ کرم طالب علم کی تصویر منتخب کریں')),
        );
        return;
      }

      setState(() => isUploading = true);

      final imageData = await uploadImage(selectedImage!);
      if (imageData == null) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تصویر اپلوڈ کرنے میں مسئلہ آیا')),
        );
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('students').add({
          'name': nameController.text.trim(),
          'fatherName': fatherNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'bayForm': bayFormController.text.trim(),
          'address': addressController.text.trim(),
          'dob': dobController.text.trim(),
          'education': educationController.text.trim(),
          'imageUrl': imageData['imageUrl'],
          'publicId': imageData['publicId'],
          'timestamp': FieldValue.serverTimestamp(),
        });

        nameController.clear();
        fatherNameController.clear();
        phoneController.clear();
        bayFormController.clear();
        addressController.clear();
        educationController.clear();
        dobController.clear();
        setState(() => selectedImage = null);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('کامیابی'),
            content: const Text('طالب علم کا ریکارڈ کامیابی سے محفوظ ہو گیا ہے'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ٹھیک ہے'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ریکارڈ محفوظ نہیں ہو سکا: $e')),
        );
      } finally {
        setState(() => isUploading = false);
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.deepPurple.shade50,
        ),
        validator: (value) => value == null || value.isEmpty ? 'یہ فیلڈ ضروری ہے' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نیا طالب علم شامل کریں', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.deepPurple.shade100,
                    backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                    child: selectedImage == null
                        ? const Icon(Icons.camera_alt, size: 35, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(nameController, 'نام طالب علم'),
                _buildTextField(fatherNameController, 'ولدیت'),
                _buildTextField(phoneController, 'فون نمبر', keyboardType: TextInputType.phone),
                _buildTextField(bayFormController, 'بے فارم نمبر'),
                _buildTextField(addressController, 'پتہ'),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: _buildTextField(dobController, 'تاریخ پیدائش'),
                  ),
                ),
                _buildTextField(educationController, 'سابقہ تعلیم'),
                const SizedBox(height: 20),
                isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: _saveStudentRecord,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('محفوظ کریں', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
