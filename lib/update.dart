import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditStudentScreen extends StatefulWidget {
  final String studentId;
  final Map<String, dynamic> studentData;

  const EditStudentScreen({
    super.key,
    required this.studentId,
    required this.studentData,
  });

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController fatherNameController;
  late TextEditingController phoneController;
  late TextEditingController bayFormController;
  late TextEditingController addressController;
  late TextEditingController dobController;
  late TextEditingController educationController;

  File? selectedImage;
  String? imageUrl;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.studentData['name']);
    fatherNameController = TextEditingController(text: widget.studentData['fatherName']);
    phoneController = TextEditingController(text: widget.studentData['phone']);
    bayFormController = TextEditingController(text: widget.studentData['bayForm']);
    addressController = TextEditingController(text: widget.studentData['address']);
    dobController = TextEditingController(text: widget.studentData['dob']);
    educationController = TextEditingController(text: widget.studentData['education']);
    imageUrl = widget.studentData['imageUrl'];
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
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
      return jsonData['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isUploading = true);

      String? finalImageUrl = imageUrl;
      if (selectedImage != null) {
        final uploaded = await _uploadImage(selectedImage!);
        if (uploaded == null) {
          setState(() => isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تصویر اپلوڈ نہیں ہوئی")));
          return;
        }
        finalImageUrl = uploaded;
      }

      try {
        await FirebaseFirestore.instance.collection('students').doc(widget.studentId).update({
          'name': nameController.text.trim(),
          'fatherName': fatherNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'bayForm': bayFormController.text.trim(),
          'address': addressController.text.trim(),
          'dob': dobController.text.trim(),
          'education': educationController.text.trim(),
          'imageUrl': finalImageUrl,
        });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('✅ کامیابی'),
            content: Text('ریکارڈ کامیابی سے اپڈیٹ ہو گیا'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ٹھیک ہے'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خرابی: $e')));
      } finally {
        setState(() => isUploading = false);
      }
    }
  }

  Widget _buildField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
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
        title: const Text("ریکارڈ اپڈیٹ کریں", style: TextStyle(color: Colors.white)),
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
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : imageUrl != null
                        ? NetworkImage(imageUrl!) as ImageProvider
                        : null,
                    child: selectedImage == null && imageUrl == null
                        ? const Icon(Icons.camera_alt, size: 35, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                _buildField(nameController, 'نام طالب علم'),
                _buildField(fatherNameController, 'ولدیت'),
                _buildField(phoneController, 'فون نمبر', keyboardType: TextInputType.phone),
                _buildField(bayFormController, 'بے فارم نمبر'),
                _buildField(addressController, 'پتہ'),
                _buildField(dobController, 'تاریخ پیدائش'),
                _buildField(educationController, 'سابقہ تعلیم'),
                const SizedBox(height: 20),
                isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: _updateStudent,
                  icon: const Icon(Icons.update,color: Colors.white,),
                  label: const Text('اپڈیٹ کریں',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
