import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:project_shop/configs/app_configs.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  Future<NotificationService> init() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(
      AppConfigs.oneSignalAppId,
    );

    await OneSignal.Notifications.requestPermission(true);

    // _setupNotificationListeners();

    return this;
  }

  // void _setupNotificationListeners() {
  //   OneSignal.Notifications.addClickListener((event) {
  //     final data = event.notification.additionalData;

  //     print("Notification clicked");
  //     print(data);

  //     // _handleNavigation(data);
  //   });

  //   /// Khi app foreground
  //   OneSignal.Notifications.addForegroundWillDisplayListener(
  //     (event) {
  //       print("Foreground notification");
  //       print(event.notification.jsonRepresentation());
  //     },
  //   );
  // }

  // void _handleNavigation(Map<String, dynamic>? data) {
  //   if (data == null) return;

  //   final screen = data['screen'];

  //   switch (screen) {
  //     case 'order_detail':
  //       final orderId = data['orderId'];

  //       Get.toNamed(
  //         '/order-detail',
  //         arguments: orderId,
  //       );
  //       break;

  //     case 'chat':
  //       Get.toNamed('/chat');
  //       break;
  //   }
  // }

  Future<void> login(String userId) async {
    OneSignal.login(userId);
  }

  Future<void> logout() async {
    OneSignal.logout();
  }
}
