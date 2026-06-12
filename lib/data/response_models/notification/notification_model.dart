class NotificationListResponse {
  final int? status;
  final String? message;
  final NotificationPaginationModel? data;
  final int unreadCount;

  NotificationListResponse({
    this.status,
    this.message,
    this.data,
    required this.unreadCount,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      status: _toIntNullable(json['status']),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? NotificationPaginationModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
      unreadCount: _toInt(json['unread_count']),
    );
  }
}

class NotificationReadResponse {
  final int? status;
  final String? message;
  final NotificationModel? data;
  final int unreadCount;

  NotificationReadResponse({
    this.status,
    this.message,
    this.data,
    required this.unreadCount,
  });

  factory NotificationReadResponse.fromJson(Map<String, dynamic> json) {
    return NotificationReadResponse(
      status: _toIntNullable(json['status']),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? NotificationModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      unreadCount: _toInt(json['unread_count']),
    );
  }
}

class NotificationMarkAllResponse {
  final int? status;
  final String? message;
  final int unreadCount;

  NotificationMarkAllResponse({
    this.status,
    this.message,
    required this.unreadCount,
  });

  factory NotificationMarkAllResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return NotificationMarkAllResponse(
      status: _toIntNullable(json['status']),
      message: json['message']?.toString(),
      unreadCount: data is Map<String, dynamic>
          ? _toInt(data['unread_count'])
          : _toInt(json['unread_count']),
    );
  }
}

class NotificationPaginationModel {
  final int currentPage;
  final int total;
  final int lastPage;
  final int perPage;
  final List<NotificationModel> data;

  NotificationPaginationModel({
    required this.currentPage,
    required this.total,
    required this.lastPage,
    required this.perPage,
    required this.data,
  });

  factory NotificationPaginationModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'];
    return NotificationPaginationModel(
      currentPage: _toInt(json['current_page']),
      total: _toInt(json['total']),
      lastPage: _toInt(json['last_page']),
      perPage: _toInt(json['per_page']),
      data: items is List
          ? items
              .whereType<Map<String, dynamic>>()
              .map(NotificationModel.fromJson)
              .toList()
          : <NotificationModel>[],
    );
  }
}

class NotificationModel {
  final String id;
  final String? type;
  final String? title;
  final String? message;
  final Map<String, dynamic>? data;
  final String? readAt;
  final bool isRead;
  final String? createdAt;

  NotificationModel({
    required this.id,
    this.type,
    this.title,
    this.message,
    this.data,
    this.readAt,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
      readAt: json['read_at']?.toString(),
      isRead: json['is_read'] == true || json['read_at'] != null,
      createdAt: json['created_at']?.toString(),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    String? readAt,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

int _toInt(dynamic value) => _toIntNullable(value) ?? 0;

int? _toIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
