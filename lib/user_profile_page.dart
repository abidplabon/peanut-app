// user_profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanut_mobile_app/controllers/auth_controller.dart';

class UserProfilePage extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (authController.userInfo.isNotEmpty) {
            final userInfo = authController.userInfo as Map<String, dynamic>;
            print('User Info: $userInfo'); // Add this line for additional debugging
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${userInfo['name']}'),
                SizedBox(height: 8),
                Text('Address: ${userInfo['address']}'),
                SizedBox(height: 8),
                Text('Balance: ${userInfo['balance']}'),
                // Add more fields as needed
              ],
            );
          } else {
            print('User Info is empty'); // Add this line for additional debugging
            return Center(child: Text('Error loading user information'));
          }
        }),
      ),
    );
  }
}
