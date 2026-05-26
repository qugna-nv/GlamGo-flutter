import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

const DEFAULT_INTERVAL = 600;

class DefaultInkWell extends StatefulWidget {
  const DefaultInkWell(
      {super.key,
      required this.child,
      required this.onTap,
      this.radius,
      this.background,
      this.onLongPress,
      this.rippleColor,
      this.enabled = true,
      this.labelChild,
      this.intervalMs = DEFAULT_INTERVAL});

  final Widget child;
  final double? radius;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final bool enabled;

  final Color? background;
  final Color? rippleColor;

  final int? intervalMs;
  final Widget? labelChild;

  @override
  State<DefaultInkWell> createState() => _DefaultInkWellState();
}

class _DefaultInkWellState extends State<DefaultInkWell> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return widget.enabled
        ? Material(
            borderRadius: BorderRadius.circular(widget.radius ?? 8.r),
            color: widget.background ?? ColorName.transparent,
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.black12,
              borderRadius: BorderRadius.circular(widget.radius ?? 8.r),
              onLongPress: widget.onLongPress,
              onTap: () {
                final now = DateTime.now().millisecondsSinceEpoch;
                if (now - lastTimeClicked <
                    (widget.intervalMs ?? DEFAULT_INTERVAL)) {
                  return;
                }
                lastTimeClicked = now;
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    clipBehavior: Clip.none,
                    borderRadius: BorderRadius.circular(widget.radius ?? 8.r),
                    child: Ink(
                        decoration: BoxDecoration(
                          color: widget.background ?? ColorName.transparent,
                          borderRadius:
                              BorderRadius.circular(widget.radius ?? 8.r),
                        ),
                        child: Padding(
                          padding: widget.labelChild != null
                              ? const EdgeInsets.only(top: 4)
                              : const EdgeInsets.all(0),
                          child: widget.child,
                        )),
                  ),
                  if (widget.labelChild != null)
                    Positioned(top: 0, right: 0, child: widget.labelChild!),
                ],
              ),
            ),
          )
        : widget.child;
  }
}
