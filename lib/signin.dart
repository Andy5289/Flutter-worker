import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dh/signup.dart';
import 'package:dh/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/signup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 330,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      hintText: "Enter your Email",
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      hintText: "Enter your Password",
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            bool isAuthenticated = await _authenticateUser(email, password);

                            if (isAuthenticated) {

                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => CarouselScreen()),
                              );
                            } else {
                              // Show an error message if authentication fails
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Invalid email or password"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Text("Sign In"),
                      ),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text(
                        "Do not have an account? Sign up here.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Future<bool> _authenticateUser(String email, String password) async {
    final usersRef = _database.child('userdata');

    final snapshot = await usersRef.orderByChild('email').equalTo(email).once();

    if (snapshot.snapshot.value != null) {
      final userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final userKey = userData.keys.first;

      final user = userData[userKey];
      final storedPassword = user['password'];
      String userPhoneNumber = user['phoneNumber'];

      SharedPreferences user_PhoneNumber = await SharedPreferences.getInstance();
      await user_PhoneNumber.setString('userPhoneNumber', userPhoneNumber);
      
      print("userPhoneNumber: $userPhoneNumber");

      return storedPassword == password;
    }

    return false;
  }
}
