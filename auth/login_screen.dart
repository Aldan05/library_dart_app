import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
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
                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill all fields")));
                        return;
                      }

                      setState(() => _loading = true);
                      
                      final result = await _auth.login(
                          _emailController.text.trim(), 
                          _passwordController.text.trim());
                      
                      if (mounted) setState(() => _loading = false);
                      
                      if (result == "success") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Successful!")));
                        // Navigator is handled by AuthWrapper in main.dart
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result ?? "Login Failed")));
                      }
                    },
                    child: const Text("Login"),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: const Text("Don't have an account? Register"),
            )
          ],
        ),
      ),
    );
  }
}
