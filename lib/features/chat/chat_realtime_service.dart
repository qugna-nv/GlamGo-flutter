import 'dart:async';
import 'dart:convert';

import 'package:project_shop/configs/app_configs.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/chat/chat_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRealtimeService {
  final ApiService apiService;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  ChatRealtimeService(this.apiService);

  Future<void> connect({
    required String privateChannel,
    required void Function(ChatMessageModel message) onMessage,
    required void Function() onDisconnected,
    required void Function(Object error) onError,
  }) async {
    await disconnect();

    final channel = WebSocketChannel.connect(AppConfigs.reverbWebSocketUri);
    _channel = channel;
    await channel.ready;

    _subscription = channel.stream.listen(
      (rawMessage) async {
        final event = jsonDecode(rawMessage.toString()) as Map<String, dynamic>;
        final name = event['event']?.toString();

        if (name == 'pusher:connection_established') {
          final data = _decodeData(event['data']);
          final socketId = data['socket_id']?.toString();
          if (socketId == null) return;

          final authResponse = await apiService.authorizeChatChannel({
            'socket_id': socketId,
            'channel_name': privateChannel,
          });
          final auth = authResponse is Map<String, dynamic>
              ? authResponse
              : <String, dynamic>{};
          channel.sink.add(jsonEncode({
            'event': 'pusher:subscribe',
            'data': {
              'auth': auth['auth'],
              'channel': privateChannel,
            },
          }));
          return;
        }

        if (name == 'pusher:ping') {
          channel.sink.add(jsonEncode({'event': 'pusher:pong', 'data': {}}));
          return;
        }

        if (name == 'message.sent') {
          final data = _decodeData(event['data']);
          final message = data['message'];
          if (message is Map<String, dynamic>) {
            onMessage(ChatMessageModel.fromJson(message));
          }
        }
      },
      onDone: onDisconnected,
      onError: (error) {
        onError(error);
        onDisconnected();
      },
    );
  }

  Map<String, dynamic> _decodeData(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is String) {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
    }
    return {};
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }
}
