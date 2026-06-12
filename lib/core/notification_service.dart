import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:project_shop/configs/app_configs.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();
  String? _currentExternalId;

  Future<NotificationService> init() async {
    if (AppConfigs.oneSignalAppId.isEmpty) {
      return this;
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(
      AppConfigs.oneSignalAppId,
    );

    await OneSignal.Notifications.requestPermission(true);
    await OneSignal.User.pushSubscription.optIn();
    OneSignal.User.pushSubscription.addObserver((_) {
      _syncPushSubscriptionWithBackend(_currentExternalId);
    });
    await syncLoggedInUser();

    _setupNotificationListeners();

    return this;
  }

  void _setupNotificationListeners() {
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;

      _handleNavigation(data);
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.notification.display();
    });
  }

  void _handleNavigation(Map<String, dynamic>? data) {
    if (data == null) return;

    final type = data['type']?.toString();

    switch (type) {
      case 'order_status_changed':
        Get.toNamed('/orders');
        break;
      case 'chat_message':
        Get.toNamed('/chat');
        break;
    }
  }

  Future<void> login(String userId) async {
    if (AppConfigs.oneSignalAppId.isEmpty || userId.isEmpty) {
      return;
    }

    _currentExternalId = userId;
    await OneSignal.login(userId);
    await OneSignal.User.addTagWithKey('user_id', userId);
    await _syncPushSubscriptionWithBackend(userId);
  }

  Future<void> logout() async {
    if (AppConfigs.oneSignalAppId.isEmpty) {
      return;
    }

    OneSignal.logout();
    _currentExternalId = null;
  }

  Future<void> syncLoggedInUser() async {
    if (!Get.isRegistered<SecureStorage>() || !Get.isRegistered<ApiService>()) {
      return;
    }

    final token = await Get.find<SecureStorage>().getAccessToken();
    if (token == null || token.isEmpty) {
      await logout();
      return;
    }

    try {
      final response = await Get.find<ApiService>().getCurrentUser();
      final userId = response.data?.id;
      if (userId != null) {
        await login(userId.toString());
      }
    } catch (_) {
      await logout();
    }
  }

  Future<void> _syncPushSubscriptionWithBackend(String? externalId) async {
    if (externalId == null ||
        externalId.isEmpty ||
        !Get.isRegistered<ApiService>()) {
      return;
    }

    try {
      await Get.find<ApiService>().syncPushSubscription({
        'external_id': externalId,
        'subscription_id': OneSignal.User.pushSubscription.id,
        'push_token': OneSignal.User.pushSubscription.token,
      });
    } catch (_) {
      // Push sync should not block login or app startup.
    }
  }
}
