// dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanut_mobile_app/user_profile_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Dashboard!'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.to(() => UserProfilePage());
              },
              child: Text('View User Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
