import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usmanya/home.dart';
import 'package:usmanya/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    checkSavedCredentials();
  }

  Future<void> checkSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('username');
    final savedPass = prefs.getString('password');

    if (savedPhone != null && savedPass != null) {
      phoneController.text = savedPhone;
      passwordController.text = savedPass;
      rememberMe = true;

      // خودکار لاگ ان
      WidgetsBinding.instance.addPostFrameCallback((_) {
        login();
      });
    }
  }

  Future<void> saveCredentials(String phone, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('username', phone);
      await prefs.setString('password', pass);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final phone = phoneController.text.trim();
      final email = "$phone@mail.com";
      final password = passwordController.text.trim();

      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final uid = userCredential.user!.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final role = userDoc.data()?['role'] ?? 'user';

        await saveCredentials(phone, password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeDashboard(role: role)),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "لاگ اِن ناکام ہوا")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("کچھ غلط ہو گیا، دوبارہ کوشش کریں")));
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
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("لاگ اِن", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
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

                const SizedBox(height: 10),

                CheckboxListTile(
                  value: rememberMe,
                  onChanged: (value) => setState(() => rememberMe = value ?? false),
                  title: const Text("یاد رکھیں", style: TextStyle(color: Colors.white)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.white,
                  checkColor: Colors.teal,
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade800,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading ? CircularProgressIndicator() : Text("لاگ اِن کریں"),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                  },
                  child: const Text("اکاؤنٹ نہیں ہے؟ رجسٹر کریں", style: TextStyle(color: Colors.white)),
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
      keyboardType: label.contains("فون") ? TextInputType.phone : TextInputType.text,
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
