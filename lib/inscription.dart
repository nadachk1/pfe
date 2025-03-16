import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> allergies = ['Peanuts', 'Dairy', 'Eggs', 'Shellfish'];
  List<String> selectedAllergies = [];

  List<Map<String, dynamic>> familyMembers = [];

  void registerUser() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      
      // Ajouter l'utilisateur
      var dbHelper = DatabaseHelper.instance;
      int userId = await dbHelper.insertUser({
        'name': nameController.text,
        'email': nameController.text,
        'password': nameController.text,
      });

      // Ajouter les allergies de l'utilisateur
      for (String allergy in selectedAllergies) {
        await dbHelper.insertAllergy({
          'person_id': userId,
          'type': allergy,
        });
      }

      // Ajouter les membres de famille
      for (var member in familyMembers) {
        int memberId = await dbHelper.insertFamilyMember({
          'user_id': userId,
          'name': member['name'],
          'age': member['age'],
          'relation': member['relation'],
        });

        // Ajouter les allergies des membres
        for (String allergy in member['allergies']) {
          await dbHelper.insertFamilyMemberAllergy({
            'member_id': memberId,
            'type': allergy,
          });
        }
      }

      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }

  void addFamilyMember() {
    setState(() {
      familyMembers.add({
        'name': '',
        'age': 0,
        'relation': '',
        'allergies': [],
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),

            const SizedBox(height: 10),
            Wrap(
              children: allergies.map((allergy) {
                return CheckboxListTile(
                  title: Text(allergy),
                  value: selectedAllergies.contains(allergy),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedAllergies.add(allergy);
                      } else {
                        selectedAllergies.remove(allergy);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: addFamilyMember, child: const Text("Ajouter un membre de famille")),
            
            ElevatedButton(onPressed: (){
               Navigator.pushReplacementNamed(context, '/dashboard');
            },
              child: const Text("S'inscrire")),



          
          ],
        ),
      ),
    );
  }
  }