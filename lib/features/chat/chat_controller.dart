import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/chat/chat_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/features/chat/chat_realtime_service.dart';
import 'package:project_shop/routes/app_routes.dart';

class ChatController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();
  final messageController = TextEditingController();
  final messages = <ChatMessageModel>[].obs;
  final sending = false.obs;
  final realtimeConnected = false.obs;
  final Rxn<XFile> selectedFile = Rxn<XFile>();
  final selectedFileType = ''.obs;
  final handledBy = 'bot'.obs;
  final RxnString adminName = RxnString();

  late final ChatRealtimeService _realtimeService =
      ChatRealtimeService(apiService);
  final ImagePicker _picker = ImagePicker();

  @override
  void onReady() {
    loadMessages();
    super.onReady();
  }

  Future<bool> _ensureLoggedIn() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) return true;

    Get.offNamed(Routes.login, arguments: {'redirect': Routes.chat});
    return false;
  }

  Future<void> loadMessages() async {
    if (!await _ensureLoggedIn()) return;

    isLoading.value = true;
    try {
      final response = await apiService.getChatMessages();
      final thread = response.data;
      if (thread == null) return;

      messages.assignAll(thread.messages);
      handledBy.value = thread.session?.handledBy ?? 'bot';
      adminName.value = thread.session?.adminName;
      await _connectRealtime(thread.channel);
    } catch (error) {
      Get.snackbar('Tin nhan', _errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _connectRealtime(String channel) async {
    if (channel.isEmpty) return;

    try {
      await _realtimeService.connect(
        privateChannel: channel,
        onMessage: _addMessage,
        onDisconnected: () => realtimeConnected.value = false,
      );
      realtimeConnected.value = true;
    } catch (_) {
      realtimeConnected.value = false;
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    final file = selectedFile.value;
    if ((content.isEmpty && file == null) || sending.value) return;

    sending.value = true;
    try {
      final response = await apiService.sendChatMessage(
        content.isEmpty ? null : content,
        file == null ? null : await dio.MultipartFile.fromFile(file.path),
      );
      final message = response.data;
      if (message != null) _addMessage(message);
      messageController.clear();
      clearSelectedFile();
    } catch (error) {
      Get.snackbar('Tin nhan', _errorMessage(error));
    } finally {
      sending.value = false;
    }
  }

  Future<void> pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    selectedFile.value = file;
    selectedFileType.value = 'image';
  }

  Future<void> pickVideo() async {
    final file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;
    selectedFile.value = file;
    selectedFileType.value = 'video';
  }

  void clearSelectedFile() {
    selectedFile.value = null;
    selectedFileType.value = '';
  }

  void _addMessage(ChatMessageModel message) {
    if (messages.any((item) => item.id == message.id)) return;
    messages.add(message);
    if (message.isBot) {
      handledBy.value = 'bot';
      adminName.value = null;
    }
  }

  String _errorMessage(Object error) {
    if (error is dio.DioException &&
        error.response?.data is Map<String, dynamic>) {
      return (error.response!.data as Map<String, dynamic>)['message']
              ?.toString() ??
          'Có lỗi xảy ra.';
    }
    return 'Có lỗi xảy ra.';
  }

  @override
  void onClose() {
    _realtimeService.disconnect();
    messageController.dispose();
    super.onClose();
  }
}
