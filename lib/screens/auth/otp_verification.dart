import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'controller/auth_controller.dart';

class OtpVerification extends GetView<AuthController> {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    final String email = Get.arguments?['email'] ?? "your email";

    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the OTP sent to $email",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Pinput(
              controller: otpController,
              length: 6,
              onCompleted: (pin) {
                controller.verifyOtp(pin);
              },
            ),
            const SizedBox(height: 24),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (otpController.text.isNotEmpty) {
                        controller.verifyOtp(otpController.text);
                      } else {
                        Get.snackbar("Error", "Please enter the OTP");
                      }
                    },
                    child: const Text("Verify"),
                  )),
          ],
        ),
      ),
    );
  }
}
