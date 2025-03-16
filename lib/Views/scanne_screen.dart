// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanning = true;

  Future<void> fetchProductInfo(String barcode) async {
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        final productName = data['product']['product_name'] ?? 'Produit inconnu';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Produit trouvé"),
            content: Text("Nom: $productName"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        showSnackBar("Produit non trouvé dans la base de données");
      }
    } else {
      showSnackBar("Erreur lors de la récupération des données");
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanner un produit")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                if (isScanning) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    isScanning = false; // Empêcher plusieurs scans simultanés
                    fetchProductInfo(barcodes.first.rawValue ?? "");
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => setState(() => isScanning = true),
              child: const Text("Relancer le scanner"),
            ),
          ),
        ],
      ),
    );
  }
}
