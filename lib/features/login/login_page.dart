import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/login/login_controller.dart';
import 'package:project_shop/utils/app_text_field.dart';

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
                              ? 'Đăng ký tài khoản khách hàng'
                              : 'Đăng nhập để tiếp tục',
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
                    AppTextField.standard(
                      controller: controller.nameController,
                      hintText: 'Họ tên',
                    ),
                    const SizedBox(height: 16),
                    AppTextField.standard(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Số điện thoại',
                    ),
                    const SizedBox(height: 16),
                  ],
                  AppTextField.standard(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 16),
                  AppTextField.standard(
                    controller: controller.passwordController,
                    obscureText: true,
                    hintText: 'Mật khẩu',
                    onSubmitted: (_) => controller.submit(),
                  ),
                  if (controller.isRegisterMode.value) ...[
                    const SizedBox(height: 16),
                    AppTextField.standard(
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      onSubmitted: (_) => controller.submit(),
                      hintText: 'Nhập lại mật khẩu',
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
                            ? 'Đang xử lý...'
                            : controller.isRegisterMode.value
                                ? 'ĐĂNG KÝ'
                                : 'ĐĂNG NHẬP',
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
                            ? 'Đã có tài khoản? Đăng nhập'
                            : 'Chưa có tài khoản? Đăng ký',
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
