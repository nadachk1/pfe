

import 'package:flutter/material.dart';
// ignore: unused_import
import '../utils/database_helper.dart';

class DashboardScreen extends StatefulWidget {
   const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _PageDAccueilWidgetState();
}

class _PageDAccueilWidgetState extends State<DashboardScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xE2B399F4),
          automaticallyImplyLeading: false,
          title: const Text(
            'AllergyGuard',
            style: TextStyle(
              fontFamily: 'Urbanist',
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24.0),
              onPressed: () {
                // ignore: avoid_print
                print('IconButton pressed ...');
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome back, Sarah',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 18.0,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 20.0,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xA0AD5717),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code_scanner,
                                          color: Colors.white,
                                          size: 32.0,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Scan Product',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 150.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0x8771D400),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 32.0,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Add Allergy',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Material(
                    color: Colors.transparent,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Alerts',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // ignore: avoid_print
                                    print('View more pressed');
                                  },
                                  child: const Text(
                                    'View more',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('Alert ${index + 1}'),
                                  subtitle: Text('Description of alert ${index + 1}'),
                                  trailing: const Icon(Icons.warning, color: Colors.red),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
  

