class ChatMessageModel {
  final int id;
  final int userId;
  final int? adminId;
  final String message;
  final String messageType;
  final String? fileUrl;
  final String? filePath;
  final String? fileName;
  final String? fileMime;
  final int? fileSize;
  final bool isAdmin;
  final String senderType;
  final String? senderName;
  final String? createdAt;

  ChatMessageModel({
    required this.id,
    required this.userId,
    this.adminId,
    required this.message,
    required this.messageType,
    this.fileUrl,
    this.filePath,
    this.fileName,
    this.fileMime,
    this.fileSize,
    required this.isAdmin,
    required this.senderType,
    this.senderName,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: _intValue(json['id']),
      userId: _intValue(json['user_id']),
      adminId: json['admin_id'] == null ? null : _intValue(json['admin_id']),
      message: json['message']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? 'text',
      fileUrl: json['file_url']?.toString(),
      filePath: json['file_path']?.toString(),
      fileName: json['file_name']?.toString(),
      fileMime: json['file_mime']?.toString(),
      fileSize: json['file_size'] == null ? null : _intValue(json['file_size']),
      isAdmin: json['is_admin'] == true || json['is_admin'] == 1,
      senderType: json['sender_type']?.toString() ??
          ((json['is_admin'] == true || json['is_admin'] == 1)
              ? 'admin'
              : 'customer'),
      senderName: json['sender_name']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  bool get hasFile => fileUrl != null && fileUrl!.isNotEmpty;

  bool get isImage => messageType == 'image';

  bool get isVideo => messageType == 'video';

  bool get isBot => senderType == 'bot';

  bool get isSystem => senderType == 'system' || messageType == 'system';

  bool get isCustomer => senderType == 'customer';

  static int _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ChatThreadModel {
  final String channel;
  final ChatSessionModel? session;
  final List<ChatMessageModel> messages;

  ChatThreadModel({
    required this.channel,
    this.session,
    required this.messages,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    final messages = json['messages'] as List<dynamic>? ?? [];

    return ChatThreadModel(
      channel: json['channel']?.toString() ?? '',
      session: json['session'] is Map<String, dynamic>
          ? ChatSessionModel.fromJson(json['session'] as Map<String, dynamic>)
          : null,
      messages: messages
          .whereType<Map<String, dynamic>>()
          .map(ChatMessageModel.fromJson)
          .toList(),
    );
  }
}

class ChatSessionModel {
  final String handledBy;
  final int? adminId;
  final String? adminName;
  final String? adminActiveUntil;

  ChatSessionModel({
    required this.handledBy,
    this.adminId,
    this.adminName,
    this.adminActiveUntil,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      handledBy: json['handled_by']?.toString() ?? 'bot',
      adminId: json['admin_id'] == null
          ? null
          : ChatMessageModel._intValue(json['admin_id']),
      adminName: json['admin_name']?.toString(),
      adminActiveUntil: json['admin_active_until']?.toString(),
    );
  }
}
