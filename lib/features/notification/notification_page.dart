import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_shop/data/response_models/notification/notification_model.dart';
import 'package:project_shop/features/notification/notification_controller.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.unreadCount.value > 0
                  ? 'Thông báo (${controller.unreadCount.value})'
                  : 'Thông báo',
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() {
              final canMarkAll = controller.unreadCount.value > 0;
              return TextButton(
                onPressed: canMarkAll && !controller.isMarkingAll.value
                    ? controller.markAllAsRead
                    : null,
                child: const Text('Đọc hết'),
              );
            }),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.getNotifications,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('Chưa có thông báo')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.getNotifications,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return _NotificationItem(
                  notification: notification,
                  onTap: () => controller.openNotification(notification),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRead ? ColorName.grey53 : ColorName.grey16,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isRead ? Colors.transparent : ColorName.red14,
            width: isRead ? 0 : 0.8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6, right: 10),
              decoration: BoxDecoration(
                color: isRead ? Colors.transparent : ColorName.red14,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'Thông báo',
                    style: Styles.normalTextW700(size: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((notification.message ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      notification.message!,
                      style: Styles.normalTextW400(size: 13),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(notification.createdAt),
                    style: Styles.normalTextW400(
                      size: 12,
                      color: ColorName.grey1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '';

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }
}
