import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'package:peanut_mobile_app/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Peanut Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authController.loadToken();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peanut Mobile App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await authController.login(
                  loginController.text,
                  passwordController.text,
                );
                if (authController.accessToken.isNotEmpty) {
                  // Navigate to the next screen or perform any action upon successful login
                  Get.to(DashboardPage());
                  print('Login Successful!');
                } else {
                  // Handle login failure, show error message, etc.
                  print('Login Failed!');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
