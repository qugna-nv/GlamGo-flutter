import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/utils/app_text_field.dart';
import 'package:project_shop/utils/currency_formatter.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedAmount = 0;
  bool _submitting = false;

  void _selectQuickAmount(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = CurrencyFormatter.formatNoSymbol(amount);
    });
  }

  Future<void> _topUpWallet() async {
    if (_selectedAmount <= 0 || _submitting) return;

    setState(() => _submitting = true);
    try {
      final response = await Get.find<ApiService>().topUpWallet({
        'amount': _selectedAmount,
      });
      final data = response.data;
      final paymentUrl = data is Map ? data['payment_url']?.toString() : null;

      if (paymentUrl == null || paymentUrl.isEmpty) {
        throw Exception('Payment URL khong hop le.');
      }

      final launched = await launchUrlString(
        paymentUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Khong the mo cong thanh toan.');
      }
    } catch (_) {
      _showToast(ToastStatus.fail, 'Khong the tao giao dich nap vi.');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _showToast(ToastStatus status, String message) {
    if (!Get.isRegistered<ToastWidget>()) return;

    Get.find<ToastWidget>().showToast(
      context,
      toastStatus: status,
      description: message,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nạp tiền',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nhạp số tiền (đ)',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        AppTextField.standard(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              _selectedAmount =
                                  CurrencyFormatter.parse(value).toInt();
                            });
                          },
                          inputFormatters: [
                            CurrencyInputFormatter(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          final accountBalance =
                              Get.isRegistered<AccountController>()
                                  ? Get.find<AccountController>()
                                          .user
                                          .value
                                          ?.walletBalance ??
                                      0
                                  : 0;

                          return Text(
                            'Số dư ví hiện tại: ${CurrencyFormatter.format(accountBalance)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildQuickAmountButton(100000, '100.000'),
                            const SizedBox(width: 12),
                            _buildQuickAmountButton(200000, '200.000'),
                            const SizedBox(width: 12),
                            _buildQuickAmountButton(500000, '500.000'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          'Nạp tiền',
                          CurrencyFormatter.format(_selectedAmount),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          'Tổng thanh toán',
                          CurrencyFormatter.format(_selectedAmount),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, color: Colors.grey, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Đây là chức năng nạp ví sandbox thanh toán trong ứng dụng.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: SafeArea(
              child: ElevatedButton(
                onPressed:
                    _selectedAmount > 0 && !_submitting ? _topUpWallet : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedAmount > 0
                      ? ColorName.orange18
                      : const Color(0xFFE0E0E0),
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _submitting ? 'Đang nạp...' : 'Nạp tiền ngay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _selectedAmount > 0
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButton(int value, String label) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _selectQuickAmount(value),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
            color: isTotal ? const Color(0xFFFF5722) : Colors.black,
          ),
        ),
      ],
    );
  }
}
