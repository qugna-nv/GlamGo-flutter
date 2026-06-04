import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_shop/data/response_models/chat/chat_model.dart';
import 'package:project_shop/features/chat/chat_controller.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:video_player/video_player.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final handledBy = controller.handledBy.value;
          final adminName = controller.adminName.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ho tro truc tuyen'),
              Text(
                handledBy == 'admin'
                    ? 'Dang duoc ho tro boi ${adminName ?? 'quan tri vien'}'
                    : 'GlamGo Bot dang ho tro',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          );
        }),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.circle,
                  size: 11,
                  color: controller.realtimeConnected.value
                      ? Colors.green
                      : Colors.grey,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text('Hay gui tin nhan de duoc ho tro.'),
                );
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final position = controller.messages.length - index - 1;
                  return _MessageBubble(controller.messages[position]);
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    final file = controller.selectedFile.value;
                    if (file == null) return const SizedBox.shrink();

                    return _SelectedFilePreview(
                      path: file.path,
                      type: controller.selectedFileType.value,
                      onRemove: controller.clearSelectedFile,
                    );
                  }),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showAttachOptions(context),
                        icon: const Icon(Icons.attach_file),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller.messageController,
                          maxLength: 2000,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: 'Nhap tin nhan...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() => IconButton.filled(
                            onPressed: controller.sending.value
                                ? null
                                : controller.sendMessage,
                            icon: controller.sending.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Chon anh'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Chon video'),
              onTap: () {
                Navigator.pop(context);
                controller.pickVideo();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _MessageBubble(this.message);

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            message.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      );
    }

    final isMine = message.isCustomer;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? ColorName.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.isBot)
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'GlamGo Bot',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            if (message.isImage && message.hasFile)
              _ChatImage(url: message.fileUrl!),
            if (message.isVideo && message.hasFile)
              _ChatVideo(url: message.fileUrl!),
            if (message.message.isNotEmpty) ...[
              if (message.hasFile) const SizedBox(height: 8),
              Text(
                message.message,
                style: TextStyle(
                  color: isMine ? Colors.white : Colors.black87,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _time(message.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: isMine ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _time(String? date) {
    final parsed = DateTime.tryParse(date ?? '')?.toLocal();
    return parsed == null ? '' : DateFormat('HH:mm dd/MM').format(parsed);
  }
}

class _SelectedFilePreview extends StatelessWidget {
  final String path;
  final String type;
  final VoidCallback onRemove;

  const _SelectedFilePreview({
    required this.path,
    required this.type,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: type == 'image'
                ? Image.file(
                    File(path),
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 58,
                    height: 58,
                    color: Colors.black12,
                    child: const Icon(Icons.play_circle_fill),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              path.split(Platform.pathSeparator).last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _ChatImage extends StatelessWidget {
  final String url;

  const _ChatImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 220,
        fit: BoxFit.cover,
        placeholder: (_, __) => const SizedBox(
          width: 220,
          height: 160,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) => const SizedBox(
          width: 220,
          height: 120,
          child: Center(child: Icon(Icons.broken_image)),
        ),
      ),
    );
  }
}

class _ChatVideo extends StatefulWidget {
  final String url;

  const _ChatVideo({required this.url});

  @override
  State<_ChatVideo> createState() => _ChatVideoState();
}

class _ChatVideoState extends State<_ChatVideo> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SizedBox(
        width: 220,
        height: 140,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            if (!_controller.value.isPlaying)
              const Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
          ],
        ),
      ),
    );
  }
}
