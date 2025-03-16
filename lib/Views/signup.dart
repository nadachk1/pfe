// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:my_app/Components/button.dart';
import 'package:my_app/Components/colors.dart';
import 'package:my_app/Components/textfield.dart';
import 'package:my_app/JSON/users.dart';
import 'package:my_app/Views/login.dart';
import 'dart:async';
import '../SQLite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  String? selectedAllergy;
  final db = DatabaseHelper();

  final List<String> allergies = [
    "Gluten", "Lactose", "Fruits à coque", "Œufs", "Poisson", "Arachides", "Autre"
  ];

  @override
  void initState() {
    super.initState();
    db._initDB();
  }

  signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas.")),
      );
      return;
    }

    var res = await db.createUser(Users(
      fullName: fullName.text,
      email: email.text,
      usrName: usrName.text,
      password: password.text,
      allergies: selectedAllergy != null ? [selectedAllergy!] : ["Non spécifié"],
    ));

    if (res > 0) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'inscription. Veuillez réessayer.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Register New Account",
                      style: TextStyle(color: primaryColor, fontSize: 40, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hint: "Full name",
                    icon: Icons.person,
                    controller: fullName,
                    validator: (value) => value!.isEmpty ? "Ce champ est requis" : null,
                  ),
                  InputField(
                    hint: "Email",
                    icon: Icons.email,
                    controller: email,
                    validator: (value) {
                      if (value!.isEmpty) return "Ce champ est requis";
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Veuillez entrer un email valide";
                      }
                      return null;
                    },
                  ),
                  InputField(
                    hint: "Username",
                    icon: Icons.account_circle,
                    controller: usrName,
                    validator: (value) => value!.isEmpty ? "Ce champ est requis" : null,
                  ),
                  InputField(
                    hint: "Password",
                    icon: Icons.lock,
                    controller: password,
                    passwordInvisible: true,
                    validator: (value) {
                      if (value!.isEmpty) return "Ce champ est requis";
                      if (value.length < 6) return "Le mot de passe doit avoir au moins 6 caractères";
                      return null;
                    },
                  ),
                  InputField(
                    hint: "Re-enter password",
                    icon: Icons.lock,
                    controller: confirmPassword,
                    passwordInvisible: true,
                    validator: (value) => value!.isEmpty ? "Ce champ est requis" : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField<String>(
                      value: selectedAllergy,
                      decoration: InputDecoration(
                        labelText: "Sélectionnez une allergie",
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: allergies.map((String allergy) {
                        return DropdownMenuItem<String>(
                          value: allergy,
                          child: Text(allergy),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAllergy = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Button(
                    label: "SIGN UP",
                    press: () {
                      signUp();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: const Text("LOGIN"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on DatabaseHelper {
  void _initDB() {}
}




class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Inscription réussie !",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
    );
  }
}
