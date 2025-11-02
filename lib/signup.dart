import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usmanya/firs_tlogin.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController(); // اب یہی user name ہے
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;

  void signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final phone = phoneController.text.trim();
      final email = "$phone@mail.com"; // email کی صورت میں transform

      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: passwordController.text.trim(),
        );

        // Firestore میں صرف email + role محفوظ ہوگا
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("رجسٹریشن کامیاب! لاگ اِن کریں")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "رجسٹریشن ناکام")));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("رجسٹریشن", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),

                _buildField("فون نمبر", Icons.phone, false, phoneController, validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'فون نمبر درج کریں';
                  } else if (!RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                    return '11 ہندسوں والا درست فون نمبر درج کریں';
                  }
                  return null;
                }),

                const SizedBox(height: 20),

                _buildField("پاس ورڈ", Icons.lock, true, passwordController, validator: (value) {
                  if (value == null || value.length < 6) return 'کم از کم 6 حروف درکار ہیں';
                  return null;
                }),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: isLoading ? null : signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading ? CircularProgressIndicator() : Text("رجسٹر کریں"),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                  child: const Text("پہلے سے اکاؤنٹ ہے؟ لاگ اِن کریں", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, bool isPassword, TextEditingController controller, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      validator: validator,
      keyboardType: label.contains('فون') ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white),
          onPressed: () => setState(() => isObscure = !isObscure),
        )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
