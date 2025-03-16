// // ignore_for_file: avoid_print

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'database_helper.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final db = DatabaseHelper.instance;

//   // Test : Ajouter un utilisateur
//   int userId = await db.insertUser({
//     'name': 'Nada Chakri',
//     'email': 'nada@example.com',
//     'password': 'securepassword'
//   });
//   print('Utilisateur ajouté avec ID: $userId');

//   // Test : Ajouter un membre de famille
//   int memberId = await db.insertFamilyMember({
//     'user_id': userId,
//     'name': 'Amine Chakri',
//     'age': 15,
//     'relation': 'Frère'
//   });
//   if (kDebugMode) {
//     print('Membre de famille ajouté avec ID: $memberId');
//   }

//   // Test : Ajouter une allergie
//   int allergyId = await db.insertAllergy({'type': 'Gluten'});
//   // ignore: duplicate_ignore
//   // ignore: avoid_print
//   print('Allergie ajoutée avec ID: $allergyId');

//   // Associer l'allergie à l'utilisateur
//   await db.insertUserAllergy({'user_id': userId, 'allergy_id': allergyId});
//   print('Allergie associée à l\'utilisateur');

//   // Associer l'allergie au membre de famille
//   await db.insertFamilyMemberAllergy({'member_id': memberId, 'allergy_id': allergyId});
//   print('Allergie associée au membre de famille');

//   // Test : Récupérer tous les utilisateurs
//   List<Map<String, dynamic>> users = await db.getUsers();
//   print('Liste des utilisateurs : $users');

//   // Test : Récupérer les membres de famille de l'utilisateur
//   List<Map<String, dynamic>> familyMembers = await db.getFamilyMembers(userId);
//   print('Membres de famille de l\'utilisateur : $familyMembers');

//   // Test : Récupérer les allergies de l'utilisateur
//   List<Map<String, dynamic>> userAllergies = await db.getUserAllergies(userId);
//   print('Allergies de l\'utilisateur : $userAllergies');

//   // Test : Récupérer les allergies du membre de famille
//   List<Map<String, dynamic>> memberAllergies = await db.getFamilyMemberAllergies(memberId);
//   print('Allergies du membre de famille : $memberAllergies');
// }
