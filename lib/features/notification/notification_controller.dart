import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/notification/notification_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

class NotificationController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isMarkingAll = false.obs;

  @override
  void onReady() {
    _loadIfLoggedIn(redirectIfUnauthenticated: false, showErrors: false);
    super.onReady();
  }

  Future<void> _loadIfLoggedIn({
    bool redirectIfUnauthenticated = true,
    bool showErrors = true,
  }) async {
    if (!await ensureLoggedIn(
      redirectIfUnauthenticated: redirectIfUnauthenticated,
      showMessage: showErrors,
    )) {
      return;
    }
    await getNotifications(
      redirectIfUnauthenticated: redirectIfUnauthenticated,
      showErrors: showErrors,
    );
  }

  Future<bool> ensureLoggedIn({
    bool redirectIfUnauthenticated = true,
    bool showMessage = true,
  }) async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    clear();
    if (showMessage) {
      Get.snackbar('Dang nhap', 'Vui long dang nhap de xem thong bao.');
    }
    if (redirectIfUnauthenticated) {
      Get.offNamed(Routes.login, arguments: {'redirect': Routes.notifications});
    }
    return false;
  }

  Future<void> getNotifications({
    bool redirectIfUnauthenticated = true,
    bool showErrors = true,
  }) async {
    if (!await ensureLoggedIn(
      redirectIfUnauthenticated: redirectIfUnauthenticated,
      showMessage: showErrors,
    )) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiService.getNotifications(20);
      notifications.assignAll(response.data?.data ?? []);
      unreadCount.value = response.unreadCount;
    } catch (error) {
      if (showErrors) {
        Get.find<ToastWidget>().showToast(
          Get.context!,
          title: 'Thất bại',
          toastStatus: ToastStatus.fail,
          description: _getErrorMessage(error),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    notifications.clear();
    unreadCount.value = 0;
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.id.isEmpty || notification.isRead) return;

    try {
      final response = await apiService.markNotificationAsRead(notification.id);
      final index =
          notifications.indexWhere((item) => item.id == notification.id);
      if (index != -1) {
        notifications[index] = response.data ??
            notifications[index].copyWith(
              isRead: true,
              readAt: DateTime.now().toIso8601String(),
            );
      }
      unreadCount.value = response.unreadCount;
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    }
  }

  Future<void> markAllAsRead() async {
    if (notifications.isEmpty || unreadCount.value == 0) return;

    isMarkingAll.value = true;
    try {
      final response = await apiService.markAllNotificationsAsRead();
      notifications.assignAll(
        notifications
            .map(
              (item) => item.copyWith(
                isRead: true,
                readAt: item.readAt ?? DateTime.now().toIso8601String(),
              ),
            )
            .toList(),
      );
      unreadCount.value = response.unreadCount;
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    } finally {
      isMarkingAll.value = false;
    }
  }

  Future<void> openNotification(NotificationModel notification) async {
    await markAsRead(notification);

    switch (notification.type) {
      case 'order_status_changed':
        Get.toNamed(Routes.orders);
        break;
      case 'chat_message':
        Get.toNamed(Routes.chat);
        break;
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Co loi xay ra.';
      }
    }
    return 'Co loi xay ra.';
  }
}
