
import 'package:flutter/material.dart';
// ignore: unused_import
import '../utils/database_helper.dart';


class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          IntroPage('Gérez vos allergies facilement', 'assets/images/allergy1.png'),
          IntroPage('Scannez les produits et vérifiez leur compatibilité', 'assets/images/allergy2.png'),
          IntroPage('Protégez votre famille', 'assets/images/allergy33.png', isLast: true, context: context),
        ],
      ),
    );
  }
}

// ignore: duplicate_ignore
// ignore: non_constant_identifier_names
Widget IntroPage(String text, String imagePath, {bool isLast = false, BuildContext? context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(imagePath, height: 200),
      const SizedBox(height: 20),
      Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      isLast
          ? ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context!, '/signup'),
              child: const Text("Commencer"))
          : const Icon(Icons.arrow_downward, size: 40, color: Colors.blue),
    ],
  );
}
