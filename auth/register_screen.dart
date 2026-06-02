import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields")));
                           return;
                        }
                        
                        setState(() => _loading = true);
                        
                        try {
                          final result = await _auth.signUp(
                              _emailController.text.trim(), 
                              _passwordController.text.trim(),
                              _nameController.text.trim()
                          );
                          
                          setState(() => _loading = false);
                          
                          if (result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Registration Successful!")));
                            Navigator.pop(context); 
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Registration Failed. Check your connection or rules.")));
                          }
                        } catch (e) {
                          setState(() => _loading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")));
                        }
                      },
                      child: const Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
