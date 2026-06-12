import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/features/order/order_controller.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

class PaymentDeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  final Set<String> _handledLinks = <String>{};

  Future<PaymentDeepLinkService> init() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink);
    }

    _subscription = _appLinks.uriLinkStream.listen(_handleLink);
    return this;
  }

  void _handleLink(Uri uri) {
    if (uri.scheme != 'projectshop' || uri.host != 'payment-result') {
      return;
    }

    final key = uri.toString();
    if (_handledLinks.contains(key)) return;
    _handledLinks.add(key);

    final status = uri.queryParameters['status'];
    final orderId = uri.queryParameters['order_id'];
    final orderCode = uri.queryParameters['order_code'];
    final type = uri.queryParameters['type'] ??
        ((orderId == null || orderId.isEmpty) &&
                (orderCode == null || orderCode.isEmpty)
            ? 'wallet'
            : 'order');
    final success = status == 'success';
    final message = uri.queryParameters['message'] ??
        (success ? 'Thanh toan thanh cong.' : 'Thanh toan chua thanh cong.');

    if (type == 'wallet') {
      _refreshAccount();
      if (Get.currentRoute == Routes.accountDetails) {
        Get.until((route) => route.settings.name == Routes.accountDetails);
      } else {
        _openFromMain(Routes.accountDetails);
      }
    } else {
      _refreshCartAndOrders();
      _openFromMain(Routes.orders);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.context;
      if (context == null || !Get.isRegistered<ToastWidget>()) return;

      Get.find<ToastWidget>().showToast(
        context,
        toastStatus: success ? ToastStatus.success : ToastStatus.fail,
        description: message,
      );
    });
  }

  void _refreshCartAndOrders() {
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().getCart(
        redirectIfUnauthenticated: false,
        showErrors: false,
      );
    }

    if (Get.isRegistered<OrderController>()) {
      Get.find<OrderController>().getOrders();
    }
  }

  void _refreshAccount() {
    if (Get.isRegistered<AccountController>()) {
      Get.find<AccountController>().loadCurrentUser();
    }
  }

  void _openFromMain(String route) {
    Get.offAllNamed(Routes.initPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.toNamed(route);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
