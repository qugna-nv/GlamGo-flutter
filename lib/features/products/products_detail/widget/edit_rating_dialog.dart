import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/data/response_models/products/product_rating_model.dart';

typedef SaveRatingCallback = Future<void> Function({
  required String fullname,
  required String phone,
  required String comment,
  required int ratingValue,
});

class EditRatingDialog extends StatefulWidget {
  const EditRatingDialog({
    super.key,
    required this.rating,
    required this.isSubmitting,
    required this.onSave,
  });

  final ProductRatingModel rating;
  final RxBool isSubmitting;
  final SaveRatingCallback onSave;

  @override
  State<EditRatingDialog> createState() => _EditRatingDialogState();
}

class _EditRatingDialogState extends State<EditRatingDialog> {
  late final TextEditingController _commentController;
  late int _selectedRating;

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(text: widget.rating.comment ?? '');
    _selectedRating = widget.rating.ratingValue;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sửa đánh giá'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                final value = index + 1;
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minHeight: 36,
                    minWidth: 36,
                  ),
                  icon: Icon(
                    Icons.star,
                    color:
                        value <= _selectedRating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => setState(() => _selectedRating = value),
                );
              }),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Nội dung đánh giá'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Huỷ'),
        ),
        Obx(
          () => TextButton(
            onPressed: widget.isSubmitting.value
                ? null
                : () => widget.onSave(
                      fullname: widget.rating.fullname ?? '',
                      phone: widget.rating.phone ?? '',
                      comment: _commentController.text.trim(),
                      ratingValue: _selectedRating,
                    ),
            child: widget.isSubmitting.value
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Lưu'),
          ),
        ),
      ],
    );
  }
}
