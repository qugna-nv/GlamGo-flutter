import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/login/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 72),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'FASHION STORE',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.isRegisterMode.value
                              ? 'Dang ky tai khoan khach hang'
                              : 'Dang nhap de tiep tuc',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (controller.isRegisterMode.value) ...[
                    TextField(
                      controller: controller.nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Ho ten',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'So dien thoai',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    textInputAction: controller.isRegisterMode.value
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onSubmitted: (_) => controller.submit(),
                    decoration: InputDecoration(
                      labelText: 'Mat khau',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (controller.isRegisterMode.value) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.submit(),
                      decoration: InputDecoration(
                        labelText: 'Nhap lai mat khau',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        controller.isLoading.value
                            ? 'Dang xu ly...'
                            : controller.isRegisterMode.value
                                ? 'DANG KY'
                                : 'DANG NHAP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.goToRegister,
                      child: Text(
                        controller.isRegisterMode.value
                            ? 'Da co tai khoan? Dang nhap'
                            : 'Chua co tai khoan? Dang ky',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 72),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
