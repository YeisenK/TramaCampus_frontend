import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBack = true,
    this.actions,
    this.bottom,
    this.centerTitle = false,
  });

  final String? title;
  final Widget? titleWidget;
  final bool showBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title:
          titleWidget ??
          (title != null
              ? Text(title!, style: AppTextStyles.titleMd(cs.onSurface))
              : null),
      centerTitle: centerTitle,
      actions: actions != null
          ? [...actions!, const SizedBox(width: AppSpacing.space2)]
          : null,
      bottom: bottom,
    );
  }
}
