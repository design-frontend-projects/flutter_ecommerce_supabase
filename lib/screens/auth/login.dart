import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/auth_controller.dart';

class Login extends GetView<AuthController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login to your account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  Text("Let's create your account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade400))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email",
                    filled: true,
                    border: OutlineInputBorder( // Outline border style
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration:  InputDecoration(labelText: "Password", filled: true,
                    border: OutlineInputBorder( // Outline border style
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed('/auth/forgot-password'),
                    child: const Text("Forgot Password?"),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Obx(() => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        :
                        ElevatedButton(
                          onPressed: () {
                            controller.login(
                              emailController.text,
                              passwordController.text,
                            );
                          },
                          child: const Text("Login"),
                        ))
                    ,
                    ElevatedButton(onPressed: () {
                        Get.toNamed('/');
                      }, child: Text("Home"))
                  ],
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/auth/register'),
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


