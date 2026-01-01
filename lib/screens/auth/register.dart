import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/auth_controller.dart';

class Register extends GetView<AuthController> {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 5,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Create an account", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                  Text("Let's create your account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade400))
                ],
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name", filled: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", filled: true),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password", filled: true),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => controller.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        animationDuration: Duration(milliseconds: 100)
                      ),
                      onPressed: () {
                        controller.register(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      child: Text("Create an account"),
                    ))
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }
}
