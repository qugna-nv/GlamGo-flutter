import 'package:flutter/material.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class AppFieldGroup extends StatelessWidget {
  const AppFieldGroup({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.child,
  });

  final String label;
  final bool isRequired;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Styles.normalTextW400(
                color: ColorName.textPrimaryLight,
              ).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: ColorName.red13)),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
