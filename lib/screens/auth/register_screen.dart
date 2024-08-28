import 'package:blogapp/screens/auth/login_screen.dart';
import 'package:blogapp/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  "Register",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Text('Please enter the following details to get started'),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: fullName,
                  decoration: const InputDecoration(hintText: 'Fullname'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your fullname';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            startRegister();
                          }
                        },
                        child: const Text('Register')),
              ],
            ),
          ),
        ),
        OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: const Text("Already have an account ? Login here")),
        const SizedBox(
          height: 15,
        )
      ],
    ));
  }

  startRegister() async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      result.user?.updateDisplayName(fullName.text);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScree()),
          (route) => false);
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? ""),
      ));
    }
  }
}
