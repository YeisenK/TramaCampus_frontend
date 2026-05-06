import 'package:flutter/material.dart';

// Renders [child] only when [condition] is true.
// Used to gate research_interests on research ∈ modes and
// available_days on study ∈ modes.
class ConditionalSection extends StatelessWidget {
  const ConditionalSection({
    super.key,
    required this.condition,
    required this.child,
    this.placeholder,
  });

  final bool condition;
  final Widget child;
  // Optional placeholder when condition is false (e.g. a locked tile).
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    if (condition) return child;
    return placeholder ?? const SizedBox.shrink();
  }
}
